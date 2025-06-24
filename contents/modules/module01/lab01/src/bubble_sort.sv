//------------------------------------------------------------------------------
// File Name: bubble_sort.sv
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
  input  logic [5:0]  card_in,       // 6-bit encoded card input
  output logic        hand_full,     // Flag when all 5 cards are stored
  output logic [5:0]  hand [4:0]     // Sorted array to store the 5-card hand, used in Module 2
);

  // Internal counter to track the number of cards written
  logic [2:0] card_counter;
  logic [5:0] unsorted_hand [4:0];
  logic [5:0] sorted_hand [4:0];

  // Assign the hand_full flag based on the number of cards written
  assign hand_full = (card_counter == 3'd5);
  assign hand = sorted_hand;

  // Storage for the hand
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      card_counter <= 3'd0;
      for (int i = 0; i < 5; i++) begin
        unsorted_hand[i] <= 6'd0;
        sorted_hand[i] <= 6'd0;
      end
    end else begin
      if (we && card_counter < 5) begin
        unsorted_hand[waddr] <= card_in;
        card_counter <= card_counter + 1;
      end
    end
  end

  // Optional: Bubble sort logic to sort the hand once hand is full
  always_comb begin
    sorted_hand = unsorted_hand; // start with a copy
    if (hand_full) begin
      for (int i = 0; i < 4; i++) begin
        for (int j = 0; j < 4 - i; j++) begin
          // use a separate variable declaration block
          logic [5:0] temp;
          if (sorted_hand[j] > sorted_hand[j+1]) begin
            temp = sorted_hand[j];
            sorted_hand[j] = sorted_hand[j+1];
            sorted_hand[j+1] = temp;
          end
        end
      end
    end
  end

endmodule
