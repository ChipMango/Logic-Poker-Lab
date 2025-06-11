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
  input  logic        clk,           // Clock input
  input  logic        rst_n,         // Reset input
  input  logic        tbl_game_start, // Signal to start the game
  output logic        cr_cmdvld,     // Command valid signal
  output logic [2:0]  cr_cmd,        // Command signal
  input  logic        cr_ack         // Acknowledge signal from the dealer
);

  // Placeholder logic for Module 0 to test environment setup
 // always_ff @(posedge clk or negedge rst_n) begin
 //   if (!rst_n)
//      cr_cmdvld <= 0;
//    else
//      cr_cmdvld <= 1;  // Set to 1 for the smoke test
  end

endmodule













