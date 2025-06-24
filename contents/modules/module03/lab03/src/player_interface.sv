//------------------------------------------------------------------------------
// File Name:player_interface.sv
// Description: module that integrates memory, hand evaluator, and command generator.
// Author: <Student Name>
// Date: <Date>
// Version: 1.0
// Project: ChipMango Lab 03 - Digitally Representing Poker Cards
// License: ChipMango Confidential - For educational purposes only
//------------------------------------------------------------------------------
// Revision History:
//   v1.0 - 07/06/25: Initial file created with module template
//------------------------------------------------------------------------------

module player_interface (
  input  logic        clk,
  input  logic        rst_n,
  input  logic        trigger,       // Pulse to start command
  input  logic [2:0]  action_code,   // Action to issue
  input  logic        cr_ack,        // Dealer ACK
  input  logic [7:0]  cr_rdata,      // Optional incoming data
  output logic [2:0]  cr_cmd,        // Command to Dealer
  output logic        cr_cmdvld,     // Command valid
  output logic        cmd_done,      // Indicates command done
  output logic [7:0]  cr_wdata       // Optional outbound data (e.g. raise)
);

  // --------------------------------------------------------------------------
  // Internal Hand Memory (from Module 1)
  // --------------------------------------------------------------------------
  logic [5:0] hand [4:0];      // Memory for 5 cards
  logic [2:0] card_index;      // Tracks incoming card position
  logic       store_card;      // Enable signal to store

  // --------------------------------------------------------------------------
  // Hand Evaluator (from Module 2)
  // --------------------------------------------------------------------------
  logic [3:0] hand_rank_out;

  hand_rank_evaluator u_hand_eval (
    .hand(hand),
    .hand_rank_out(hand_rank_out)
  );

  // --------------------------------------------------------------------------
  // Command Generator Instance (Module 3)
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
  // Card reception and memory logic
  // --------------------------------------------------------------------------
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      card_index <= 0;
    end else if (store_card && card_index < 5) begin
      hand[card_index] <= cr_rdata[5:0];
      card_index <= card_index + 1;
    end
  end

  // Dummy logic for now: enable store_card if action is Get Card
  assign store_card = (action_code == 3'b100 && cr_ack);

  // Optional: raise hand_rank_out via cr_wdata
  assign cr_wdata = {4'b0000, hand_rank_out};

endmodule
