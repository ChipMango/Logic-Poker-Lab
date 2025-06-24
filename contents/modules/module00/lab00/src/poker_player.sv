//------------------------------------------------------------------------------
// File Name:poker_player.sv
// Description: basic top-level module for the poker player
// Author: <Student Name>
// Date: <Date>
// Version: 1.0
// Project: ChipMango Lab 00 - Digitally Representing Poker Cards
// License: ChipMango Confidential - For educational purposes only
//------------------------------------------------------------------------------
// Revision History:
//   v1.0 - 10/06/25: Initial file created with module template
//------------------------------------------------------------------------------


module poker_player (
  input  logic        clk,
  input  logic        rst_n,
  input  logic        cr_cmdvld,  // Dealer command valid
  input  logic [2:0]  cr_cmd,     // Dealer command
  output logic        cr_ack,     // Acknowledge command
  output logic [2:0]  act_action, // Action to take
  output logic        act_ready   // Action ready signal
);

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      cr_ack     <= 0;
      act_action <= 3'b000;
      act_ready  <= 0;
    end else begin
      cr_ack     <= cr_cmdvld;       // Simply acknowledge any command
      act_ready  <= cr_cmdvld;       // Indicate ready when dealer asks
      act_action <= cr_cmd;          // Echo the dealer’s command
    end
  end

endmodule









