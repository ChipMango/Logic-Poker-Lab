//------------------------------------------------------------------------------
// File Name: multiplexing_logic.sv
// Description:  implements the card encoding logic
// Author: <Student Name>
// Date: <Date>
// Version: 1.0
// Project: ChipMango Lab 03 - Digitally Representing Poker Cards
// License: ChipMango Confidential - For educational purposes only
//------------------------------------------------------------------------------
// Revision History:
//   v1.0 - 06/06/25: Initial file created with module template
//------------------------------------------------------------------------------

  module player_interface (
  input  logic        clk,
  input  logic        rst_n,
  input  logic        tbl_game_start,      // Start of round
  input  logic        cr_ack,              // Dealer ACK
  input  logic [5:0]  cr_rdata,            // Incoming card from Dealer
  output logic [2:0]  cr_cmd,              // Command to Dealer
  output logic        cr_cmdvld,           // Command valid
  output logic        cmd_done,            // Indicates command done
  output logic [7:0]  cr_wdata             // Optional outbound data (e.g. raise)
);

  // --------------------------------------------------------------------------
  // Internal Signals
  // --------------------------------------------------------------------------
  logic [2:0]  action_code;
  logic        trigger;
  logic [5:0]  hand [4:0];        // Memory for 5 cards
  logic [2:0]  card_index;        // Tracks card input
  logic        store_card;
  logic [3:0]  hand_rank_out;
  logic [7:0]  raise_amount       = 8'd25;
  logic [7:0]  discard_card_id    = 8'd1;
  logic [7:0]  player_id          = 8'd42;
  logic [1:0]  data_sel;
  logic [7:0]  pot_size;                    // <-- NEW: Pot size storage

  // --------------------------------------------------------------------------
  // Instantiate Hand Evaluator
  // --------------------------------------------------------------------------
  hand_rank_evaluator u_hand_eval (
    .hand(hand),
    .hand_rank_out(hand_rank_out)
  );

  // --------------------------------------------------------------------------
  // Instantiate Command Generator
  // --------------------------------------------------------------------------
  command_generator u_cmd_gen (
    .clk(clk),
    .rst_n(rst_n),
    .action_code(action_code),
    .trigger(trigger),
    .cr_cmd(cr_cmd),
    .cr_cmdvld(cr_cmdvld),
    .cr_ack(cr_ack),
    .cmd_done(cmd_done)
  );

  // --------------------------------------------------------------------------
  // FSM: Issue full game sequence
  // --------------------------------------------------------------------------
  typedef enum logic [3:0] {
    IDLE,
    RECEIVE_CARDS,
    SEND_GET_STATS,
    WAIT_GET_STATS,
    SEND_GET_CARD,
    WAIT_GET_CARD,
    SEND_EXCHANGE,
    WAIT_EXCHANGE,
    SEND_REPORT,
    WAIT_REPORT,
    SEND_DECISION,
    WAIT_DECISION
  } state_t;

  state_t state, next_state;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n)
      state <= IDLE;
    else
      state <= next_state;
  end

  always_comb begin
    next_state = state;
    trigger = 0;
    store_card = 0;
    action_code = 3'b000;
    data_sel = 2'b00;

    case (state)
      IDLE: begin
        card_index = 0;
        if (tbl_game_start)
          next_state = RECEIVE_CARDS;
      end
      RECEIVE_CARDS: begin
        if (card_index < 5)
          store_card = 1;
        else
          next_state = SEND_GET_STATS;
      end
      SEND_GET_STATS: begin
        action_code = 3'b110;
        data_sel = 2'b10; // Player ID
        trigger = 1;
        next_state = WAIT_GET_STATS;
      end
      WAIT_GET_STATS: begin
        if (cmd_done) begin
          pot_size <= cr_rdata;  // <-- NEW: Latch pot size
          next_state = SEND_GET_CARD;
        end
      end
      SEND_GET_CARD: begin
        action_code = 3'b100;
        data_sel = 2'b10; // Player ID
        trigger = 1;
        next_state = WAIT_GET_CARD;
      end
      WAIT_GET_CARD: if (cmd_done) next_state = SEND_EXCHANGE;
      SEND_EXCHANGE: begin
        action_code = 3'b000;
        data_sel = 2'b01; // Discard
        trigger = 1;
        next_state = WAIT_EXCHANGE;
      end
      WAIT_EXCHANGE: if (cmd_done) next_state = SEND_REPORT;
      SEND_REPORT: begin
        action_code = 3'b000; // Report Holding
        data_sel = 2'b10;     // Player ID
        trigger = 1;
        next_state = WAIT_REPORT;
      end
      WAIT_REPORT: if (cmd_done) next_state = SEND_DECISION;
      SEND_DECISION: begin
        if (hand_rank_out >= 4'd6)
          action_code = 3'b011; // All-In
        else if (hand_rank_out >= 4'd5)
          action_code = 3'b010; // Bet
        else
          action_code = 3'b001; // Check
        data_sel = 2'b00;
        trigger = 1;
        next_state = WAIT_DECISION;
      end
      WAIT_DECISION: if (cmd_done) next_state = IDLE;
    endcase
  end

  // Card reception logic
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      card_index <= 0;
      for (int i = 0; i < 5; i++) hand[i] <= 6'd0;
    end else if (store_card && card_index < 5) begin
      hand[card_index] <= cr_rdata;
      card_index <= card_index + 1;
    end
  end

  // Data multiplexer
  always_comb begin
    unique case (data_sel)
      2'b00: cr_wdata = raise_amount;
      2'b01: cr_wdata = discard_card_id;
      2'b10: cr_wdata = player_id;
      default: cr_wdata = 8'd0;
    endcase
  end

endmodule

