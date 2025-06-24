 
  //------------------------------------------------------------------------------
// File Name: timeout_counter.sv
// Description:Game flow control FSM with timeout and error handling
// Author: <Student Name>
// Date: <Date>
// Version: 1.0
// Project: ChipMango Lab 04 - Digitally Representing Poker Cards
// License: ChipMango Confidential - For educational purposes only
//------------------------------------------------------------------------------
// Revision History:
//   v1.0 - 06/06/25: Initial file created with module template
//------------------------------------------------------------------------------

module game_fsm_controller (
  input  logic        clk,
  input  logic        rst_n,
  input  logic        tbl_game_start,
  input  logic        tbl_game_over,
  input  logic [5:0]  cr_rdata,         // Incoming card from Dealer
  input  logic        cr_ack,           // Dealer command ack
  input  logic        rank_done,        // Hand evaluation done pulse
  input  logic [3:0]  hand_rank_out,    // Hand rank from evaluator

  output logic        mem_we,           // Write enable for memory block
  output logic        rank_enable,      // Trigger to start evaluation
  output logic        cmd_trigger,      // Trigger for command generator
  output logic [5:0]  stored_card,      // Output to memory block
  output logic [2:0]  state,            // FSM state (for debug)
  output logic hand_full,
  output logic [7:0]  timeout_counter,  // Timeout counter
  output logic        error             // Error flag
);

  typedef enum logic [2:0] {
    IDLE,
    RECEIVE_CARDS,
    EVALUATE_HAND,
    DECIDE_ACTION,
    ISSUE_COMMAND,
    WAIT_FOR_ACK,
    END_ROUND,
    ERROR_STATE
  } state_t;

  state_t current_state, next_state;
  logic [2:0] card_counter;

  assign hand_full = (card_counter == 5);

  // FSM state register
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n)
      current_state <= IDLE;
    else
      current_state <= next_state;
  end

  // Timeout counter logic
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n)
      timeout_counter <= 0;
    else if (current_state == WAIT_FOR_ACK && !cr_ack)
      timeout_counter <= timeout_counter + 1;
    else
      timeout_counter <= 0;
  end

  assign error = (timeout_counter >= 8);

  // FSM next-state logic
  always_comb begin
    next_state = current_state;
    case (current_state)
      IDLE:           if (tbl_game_start) next_state = RECEIVE_CARDS;
      RECEIVE_CARDS:  if (hand_full)      next_state = EVALUATE_HAND;
      EVALUATE_HAND:  if (rank_done)      next_state = DECIDE_ACTION;
      DECIDE_ACTION:                      next_state = ISSUE_COMMAND;
      ISSUE_COMMAND:  if (cmd_trigger)    next_state = WAIT_FOR_ACK;
      WAIT_FOR_ACK:   if (cr_ack)         next_state = END_ROUND;
                      else if (error)     next_state = ERROR_STATE;
      END_ROUND:      if (tbl_game_over)  next_state = IDLE;
      ERROR_STATE:                      next_state = IDLE;
      default:                          next_state = IDLE;
    endcase
  end

  // Card counter logic
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n)
      card_counter <= 0;
    else if (current_state == RECEIVE_CARDS && !hand_full)
      card_counter <= card_counter + 1;
    else if (current_state == IDLE)
      card_counter <= 0;
  end

  // Output control logic
  always_comb begin
    mem_we       = 0;
    rank_enable  = 0;
    cmd_trigger  = 0;
    stored_card  = 6'b0;

    case (current_state)
      RECEIVE_CARDS: begin
        mem_we      = 1;
        stored_card = cr_rdata;
      end
      EVALUATE_HAND: begin
        rank_enable = 1;
      end
      ISSUE_COMMAND: begin
        cmd_trigger = 1;
      end
    endcase
  end

  assign state = current_state;

endmodule
