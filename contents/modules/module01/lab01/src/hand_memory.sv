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
  input  logic [2:0]  waddr,         // Write address (valid range: 0-4 for 5 cards)
  input  logic [5:0]  card_in,       // 6-bit  encoded card input
  output logic        hand_full,     // Flag when all 5 cards are stored
  output logic [5:0]  hand [4:0]     // Array to store the 5-card hand
);

  // Internal counter to track the number of cards written
  logic [2:0] card_counter;

  // Register file to store the 5 cards (5 entries, each 6 bits wide)
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) beg      // Reset all memory slot     hand[0] <= 6'b0;
      hand[1] <= 6'b0;
      hand[2] <= 6'b0;
      hand[3] <= 6'b0;
      hand[4] <= 6'b0;
      card_counter <= 3'b0;
    end else if (we) begin
      // Write the card to the selected memory slot
      hand[waddr] <= card_in;
      card_counter <= card_counter + 1;
      $display("Memory Write: Addr=%0d, Card=0x%02h", waddr, card_in);
    end
  end

  // Set the hand_full flag when all 5 slots are filled
  assign hand_full = (card_counter == 3'd5);

endmodule
