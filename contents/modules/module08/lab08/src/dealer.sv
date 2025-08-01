//------------------------------------------------------------------------------
// File Name: dealer.sv
// Description: Verilog file that maps hand rank to action/discard/raise based on personality.
// Author: <Student Name>
// Date: <Date>
// Version: 1.0
// Project: ChipMango Lab 08 - Digitally Representing Poker Cards
// License: ChipMango Confidential - For educational purposes only
//------------------------------------------------------------------------------
// Revision History:
//   v1.0 - 07/06/25: Initial file created with module template
//------------------------------------------------------------------------------


import tournament_cfg::*;

module dealer #(
   parameter string PERSONALITY_MODE =  tournament_cfg::PERSONALITY_MODE,
  parameter int TOURNAMENT_ROUNDS = tournament_cfg::TOURNAMENT_ROUNDS,
  parameter int DIFFICULTY = tournament_cfg::DIFFICULTY
)(
  input  logic clk,
  input  logic rst_n,

  // Player action input
  input  logic [2:0] player_action,
  input  logic       player_action_valid,

  // Card output interface to player
  output logic [7:0] cr_rdata,
  output logic       cr_ack,
  input  logic       cmd_trigger,

  // Game control signals
  output logic       tbl_game_start,
  output logic       tbl_game_over,

  // Status outputs
  output logic [15:0] tbl_pot_value,
  output logic        tbl_player_won
);

  // Internal variables:
  int current_round;
  logic game_active;
  logic [15:0] pot_value;
  logic [5:0] card_deck [0:51];  // Deck of 52 cards
  int card_index;

  // For bluffing and difficulty - simple example
logic good_mode, bad_mode, bluff_enable;
 

  // Initialize deck (simplified: 0..51)
  task init_deck();
    int i;
    for (i = 0; i < 52; i++) card_deck[i] = i;
  endtask

  // Shuffle deck using Fisher-Yates
  task shuffle_deck();
    int i, j;
    logic [5:0] temp;
    for (i = 51; i > 0; i--) begin
      j = $urandom_range(0, i);
      temp = card_deck[i];
      card_deck[i] = card_deck[j];
      card_deck[j] = temp;
    end
  endtask

  // Draw next card from deck
  function logic [5:0] draw_card();
    if (card_index < 52) begin
      $display("Dealer: Drawing card at index %0d: card=%0d", card_index, card_deck[card_index]);
      return card_deck[card_index];
    end else begin
      $display("Dealer: Deck exhausted at index %0d", card_index);
      return 6'dx;
    end
  endfunction

  // Main game FSM states
  typedef enum logic [1:0] {
    WAIT_START,
    DEAL_CARDS,
    WAIT_PLAYER_ACTION,
    ROUND_END
  } dealer_state_t;

  dealer_state_t state, next_state;

  // State transition
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      state <= WAIT_START;
    end else begin
      state <= next_state;
      $display("Dealer FSM: State=%0d card_index=%0d cr_rdata=0x%02h cr_ack=%b tbl_game_start=%b tbl_game_over=%b", 
               state, card_index, cr_rdata, cr_ack, tbl_game_start, tbl_game_over);
    end
  end

  // Next state logic
  always_comb begin
    next_state = state;
    case (state)
      WAIT_START: begin
        if (tbl_game_start) next_state = DEAL_CARDS;
      end

      DEAL_CARDS: begin
        if (card_index >= 5) next_state = WAIT_PLAYER_ACTION;
      end

      WAIT_PLAYER_ACTION: begin
        if (player_action_valid) next_state = ROUND_END;
      end

      ROUND_END: begin
        if (current_round >= TOURNAMENT_ROUNDS) next_state = WAIT_START;
        else next_state = DEAL_CARDS;
      end
    endcase
  end
  
  int rand_val,chance; 
  logic [7:0] card;
  // Main FSM actions and outputs
always_ff @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    // Reset all signals
    cr_rdata <= 8'd0;
    cr_ack <= 1'b0;
    tbl_game_start <= 1'b0;
    tbl_game_over <= 1'b0;
    pot_value <= 0;
    current_round <= 0;
    card_index <= 0;
    game_active <= 1'b0;

    // Reset modes
    good_mode <= 0;
    bad_mode <= 0;
    bluff_enable <= 0;

    $display("Dealer Reset: card_index reset to 0");
    
    init_deck();
    shuffle_deck();
  end else begin
    // Assign personality modes here, on every clock edge after reset
    if (tournament_cfg::PERSONALITY_MODE == "good") begin
      good_mode <= 1; bad_mode <= 0; bluff_enable <= 0;
    end else if (tournament_cfg::PERSONALITY_MODE == "bad") begin
      good_mode <= 0; bad_mode <= 1; bluff_enable <= 0;
    end else if (tournament_cfg::PERSONALITY_MODE == "bluff") begin
      good_mode <= 0; bad_mode <= 0; bluff_enable <= 1;
    end else if (tournament_cfg::PERSONALITY_MODE == "random") begin
      rand_val = $urandom_range(0,2);
      good_mode <= (rand_val == 0);
      bad_mode <= (rand_val == 1);
      bluff_enable <= (rand_val == 2);
    end else begin
      good_mode <= 1; bad_mode <= 0; bluff_enable <= 0;
    end

    // Your existing state machine cases here
    case (state)
      WAIT_START: begin
        tbl_game_start <= 1'b1;
        tbl_game_over <= 1'b0;
        pot_value <= 16'd100;
        current_round <= 1;
        card_index <= 0;
        game_active <= 1'b1;
        cr_ack <= 1'b0;
        $display("Dealer WAIT_START: card_index reset to 0");
      end

      DEAL_CARDS: begin
        tbl_game_start <= 1'b0;
        cr_ack <= 1'b0;

        if (card_index < 5) begin
          if (good_mode) begin
            // Good mode: send fair card immediately
            cr_rdata <= {2'b00, draw_card()};
            cr_ack <= 1'b1;
            card_index <= card_index + 1;
            $display("Dealer Good mode: sending fair card index %0d", card_index);
          end else if (bad_mode) begin
            chance = $urandom_range(0,9);
            if (chance < 3) begin
              // Delay card sending (skip this cycle)
              cr_ack <= 1'b0;
              $display("Dealer Bad mode: delaying card index %0d", card_index);
            end else if (chance < 5) begin
              // Send wrong/invalid card (zero)
              cr_rdata <= 8'h00;
              cr_ack <= 1'b1;
              card_index <= card_index + 1;
              $display("Dealer Bad mode: sending wrong card index %0d", card_index);
            end else begin
              // Normal card
              cr_rdata <= {2'b00, draw_card()};
              cr_ack <= 1'b1;
              card_index <= card_index + 1;
              $display("Dealer Bad mode: sending normal card index %0d", card_index);
            end
          end else if (bluff_enable) begin
            chance = $urandom_range(0,9);
            card = {2'b00, draw_card()};
            if (chance < 5) begin
              // 50% chance to send inverted card
              cr_rdata <= ~card;
              cr_ack <= 1'b1;
              card_index <= card_index + 1;
              $display("Dealer Bluff mode: sending inverted card index %0d", card_index);
            end else begin
              // Normal card
              cr_rdata <= card;
              cr_ack <= 1'b1;
              card_index <= card_index + 1;
              $display("Dealer Bluff mode: sending normal card index %0d", card_index);
            end
          end else begin
            // Default to good mode
            cr_rdata <= {2'b00, draw_card()};
            cr_ack <= 1'b1;
            card_index <= card_index + 1;
            $display("Dealer Default mode: sending card index %0d", card_index);
          end
        end
      end
 
        WAIT_PLAYER_ACTION: begin
          cr_ack <= 1'b0;
          cr_rdata <= 8'd0;
          if (player_action_valid) begin
            // Update pot based on player action
            case (player_action)
              3'd0: pot_value <= pot_value;        // Check
              3'd1: pot_value <= pot_value + 10;   // Bet
              3'd2: pot_value <= pot_value + 20;   // Raise
              3'd3: pot_value <= pot_value;        // Fold, no change to pot here
              default: pot_value <= pot_value;
            endcase
          end
        end

        ROUND_END: begin
          cr_ack <= 1'b0;
          cr_rdata <= 8'd0;
          if (current_round < TOURNAMENT_ROUNDS) begin
            current_round <= current_round + 1;
            card_index <= 0;
            shuffle_deck();
            tbl_game_start <= 1'b1;
            $display("Dealer ROUND_END: Starting new round %0d", current_round);
          end else begin
            tbl_game_over <= 1'b1;
            game_active <= 1'b0;
            tbl_game_start <= 1'b0;
            $display("Dealer ROUND_END: Tournament over");
          end
        end
      endcase
    end
  end

  // Determine winner (simple random for now)
  always_ff @(posedge clk) begin
    if (state == ROUND_END) begin
      tbl_player_won <= $urandom_range(0, 1);
    end
  end

endmodule

