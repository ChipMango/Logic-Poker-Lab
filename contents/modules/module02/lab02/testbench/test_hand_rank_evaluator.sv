//------------------------------------------------------------------------------
// File Name: test_hand_rank_evaluator.sv
// Description:  Testbench that applies various test cases to the hand evaluator.
// Author: <Student Name>
// Date: <Date>
// Version: 1.0
// Project: ChipMango Lab 02 - Digitally Representing Poker Cards
// License: ChipMango Confidential - For educational purposes only
//------------------------------------------------------------------------------
// Revision History:
//   v1.0 - 06/06/25: Initial file created with module template
//------------------------------------------------------------------------------

module test_hand_rank_evaluator;

  logic [5:0] hand [4:0];       // 5 input cards (encoded)
  logic [8:0] hand_rank_out;   // One-hot output

  // Instantiate the DUT
  hand_rank_evaluator dut (
    .hand(hand),
    .hand_rank_out(hand_rank_out)
  );

  // Waveform dump
  initial begin
    $shm_open("waves.shm");
    $shm_probe("ACMT");
  end

  // Task to display hand
  task display_hand();
    for (int i = 0; i < 5; i++) begin
      $display("Card[%0d] = %06b", i, hand[i]);
    end
  endtask

  // Main test sequence
  initial begin
    $display("=== Testing hand_rank_evaluator (9-bit) ===");

    // Test 1: Straight Flush (2–6 of Hearts = suit 10)
    hand[0] = 6'b000_10_0; // 2♥
    hand[1] = 6'b001_10_0; // 3♥
    hand[2] = 6'b010_10_0; // 4♥
    hand[3] = 6'b011_10_0; // 5♥
    hand[4] = 6'b100_10_0; // 6♥
    #10;
    $display("Test 1 - Straight Flush");
    display_hand();
    $display("Rank One-Hot Output = %b\n", hand_rank_out);

    // Test 2: Four of a Kind
    hand[0] = 6'b101_00_0; // 7♣
    hand[1] = 6'b101_01_0; // 7♦
    hand[2] = 6'b101_10_0; // 7♥
    hand[3] = 6'b101_11_0; // 7♠
    hand[4] = 6'b110_00_0; // 8♣
    #10;
    $display("Test 2 - Four of a Kind");
    display_hand();
    $display("Rank One-Hot Output = %b\n", hand_rank_out);

    // Test 3: Full House
    hand[0] = 6'b001_00_0; // 3♣
    hand[1] = 6'b001_01_0; // 3♦
    hand[2] = 6'b001_10_0; // 3♥
    hand[3] = 6'b100_00_0; // 6♣
    hand[4] = 6'b100_01_0; // 6♦
    #10;
    $display("Test 3 - Full House");
    display_hand();
    $display("Rank One-Hot Output = %b\n", hand_rank_out);

    // End
    $finish;
  end

endmodule
