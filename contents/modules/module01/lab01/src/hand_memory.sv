//------------------------------------------------------------------------------
// File Name: hand_memory.sv
// Description:   card memory block, implementing the register array and write logic.
// Author: <Student Name>
// Date: <Date>
// Version: 1.0
// Project: ChipMango Lab 01 - Digitally Representing Poker Cards
// License: ChipMango Confidential - For educational purposes only
//------------------------------------------------------------------------------
// Revision History:
//   v1.0 - 06/06/25: Initial file created with module template
//------------------------------------------------------------------------------


module hand_memory (
  input  logic        clk,           // Clock input
  input  logic        rst_n,         // Active low reset
  input  logic        we,            // Write Enable
  input  logic [2:0]  waddr,         // Write address (0 to 4)
  input  logic [5:0]  card_in,       // 6-bit encoded card input
  output logic        hand_full,     // Set high when 5 cards stored
  output logic [5:0]  hand [4:0]     // Output hand array
);

  // TODO: Declare internal 3-bit counter to track written cards
  // TODO: Write card_in into hand[waddr] on write enable
  // TODO: Assert hand_full when counter reaches 5
  // Optional TODO: Reset mem ory and counter when rst_n is low
  // Optional TODO: Add sorting logic (bubble sort) after hand is full

endmodule