module game_fsm_controller (
  input  logic        clk,
  input  logic        rst_n,
  input  logic        tbl_game_start,
  input  logic 
       tbl_game_over,
  input  logic [7:0]  cr_rdata,         // Incoming card from Dealer
  input  logic        cr_ack,           // Dealer command ack
  input  logic        rank_done,        // Signal from rank evaluator
  input  logic [8:0]  hand_rank_out,    // Hand rank from evaluator
  input logic        hand_full,         // Flag received from hand memory when hand memory full

  output logic        mem_we,           // Write enable for memory block
  output logic        rank_enable,      // Trigger to start evaluation
  output logic        cmd_trigger,      // Trigger for command generator
  output logic [5:0]  stored_card,      // Output to memory block
  output logic [2:0]  state             // FSM state (for debug)
 );

  typedef enum logic [2:0] {
    IDLE = 3'd0,
    WAIT_FOR_START = 3'd1,
    RECEIVE_CARD = 3'd2,
    EVALUATE_HAND = 3'd3,
    DECIDE_ACTION = 3'd4,  
    ISSUE_COMMAND = 3'd5,
    WAIT_FOR_ACK = 3'd6,
    END_ROUND = 3'd7
  } state_t;

  state_t current_state, next_state;

  logic [2:0] card_counter;
  logic mem_we_reg;
  logic rank_enable_reg;
  logic cmd_trigger_reg;
  logic [5:0] stored_card_reg;

  // String for readable state debug output
  string state_str;

  // Update the readable FSM state string
  always_comb begin
    case (current_state)
      IDLE:           state_str = "IDLE";
      WAIT_FOR_START: state_str = "WAIT_FOR_START";
      RECEIVE_CARD:   state_str = "RECEIVE_CARD";
      EVALUATE_HAND:  state_str = "EVALUATE_HAND";
      DECIDE_ACTION:  state_str = "DECIDE_ACTION";
      ISSUE_COMMAND:  state_str = "ISSUE_COMMAND";
      WAIT_FOR_ACK:   state_str = "WAIT_FOR_ACK";
      END_ROUND:      state_str = "END_ROUND";
      default:        state_str = "UNKNOWN";
    endcase
  end

  // State register and outputs
  always_ff @(posedge clk or negedge rst_n) begin
	  if (!rst_n) begin
      current_state <= IDLE;
      card_counter <= 3'd0;
      mem_we_reg <= 1'b0;
      rank_enable_reg <= 1'b0;
      cmd_trigger_reg <= 1'b0;
      stored_card_reg <= 6'd0;
    end else begin
      current_state <= next_state;

      // Default: disable pulses
      mem_we_reg <= 1'b0;
      rank_enable_reg <= 1'b0;
      cmd_trigger_reg <= 1'b0;

       $display("Time=%0t FSM State=%s CardCount=%0d mem_we=%b rank_enable=%b cmd_trigger=%b stored_card=0x%02h",
           $time, state_str, card_counter, mem_we_reg, rank_enable_reg, cmd_trigger_reg, stored_card_reg);


      case (current_state)
        RECEIVE_CARD: begin
if (cr_rdata[5:0] !== 6'dx && cr_rdata[5:0] !== 6'd0) begin
  stored_card_reg <= cr_rdata[5:0];
  mem_we_reg <= 1'b1;
  card_counter <= card_counter + 1;
  $display("Poker Player FSM: Received valid card 0x%02h, card_count=%0d", cr_rdata[5:0], card_counter+1);
end else begin
  $display("Poker Player FSM: Waiting for valid non-zero card, cr_rdata=0x%02h", cr_rdata);
end
                  end

        EVALUATE_HAND: begin
          rank_enable_reg <= 1'b1;
        end

        ISSUE_COMMAND: begin
          cmd_trigger_reg <= 1'b1;
        end

        END_ROUND: begin
          if (tbl_game_over) begin
            card_counter <= 3'd0;
          end
        end

        default: ; // no action
      endcase
    end
  end

  // Next state logic
  always_comb begin
    next_state = current_state;
    case (current_state)
      IDLE: if (tbl_game_start) next_state = WAIT_FOR_START;

      WAIT_FOR_START: next_state = RECEIVE_CARD;

      RECEIVE_CARD: begin
        if (card_counter == 3'd5)
          next_state = EVALUATE_HAND;
        else
          next_state = RECEIVE_CARD;
      end

      EVALUATE_HAND: begin
        if (rank_done)
          next_state = DECIDE_ACTION;
        else
          next_state = EVALUATE_HAND;
      end

      DECIDE_ACTION: begin
        // Here, you can add handshake/done signals if needed
        // For now, proceed immediately:
        next_state = ISSUE_COMMAND;
      end

      ISSUE_COMMAND: next_state = WAIT_FOR_ACK;

      WAIT_FOR_ACK: if (cr_ack) next_state = END_ROUND;

      END_ROUND: if (tbl_game_over) next_state = IDLE;

      default: next_state = IDLE;
    endcase
  end

initial begin
   // Wait for reset deassertion before enabling assertions
  @(negedge rst_n);
  @(posedge rst_n);

  // Assertions here
  assert property (@(posedge clk)
    disable iff (!rst_n)
    (mem_we |-> (cr_rdata[5:0] !== 6'dx && cr_rdata[5:0] !== 6'd0))
  ) else $error("mem_we asserted but cr_rdata invalid");

  assert property (@(posedge clk)
    disable iff (!rst_n)
    (current_state == RECEIVE_CARD && mem_we) |-> (card_counter == $past(card_counter) + 1)
  ) else $error("card_counter did not increment on mem_we in RECEIVE_CARD");
  // Assert card_counter reset at start states
assert property (@(posedge clk)
  disable iff (!rst_n)
  ((current_state == IDLE || current_state == WAIT_FOR_START) |-> (card_counter == 0))
) else $error("card_counter not reset in start state");

  // Assertion 1
  assert property (@(posedge clk)
    disable iff (!rst_n)
    (rank_done |-> (current_state == EVALUATE_HAND))
  ) else $error("rank_done asserted outside EVALUATE_HAND state");

  // Assertion 2
  assert property (@(posedge clk)
    disable iff (!rst_n)
    ((current_state == EVALUATE_HAND && rank_done) |-> (next_state == DECIDE_ACTION))
  ) else $error("FSM did not move to DECIDE_ACTION after rank_done");
end
  

  // Output assignments
  assign mem_we = mem_we_reg;
  assign rank_enable = rank_enable_reg;
  assign cmd_trigger = cmd_trigger_reg;
  assign stored_card = stored_card_reg;
  assign state = current_state;


endmodule

