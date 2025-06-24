 //------------------------------------------------------------------------------
// File Name:rank_encoding_tb.sv
// Description:  implements the hand ranking evaluator logic.
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

  // Inputs to the DUT
  logic [5:0] hand [4:0];

  // Output from the DUT
  logic [3:0] hand_rank_out;

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

  // Task to display the hand in readable format
  task display_hand;
    for (int i = 0; i < 5; i++) begin
      $display("Card[%0d] = %b", i, hand[i]);
    end
  endtask

  // Stimulus block
  initial begin
    $display("Starting Hand Rank Evaluation Test");

    // Test Case 1: High Card (All different)
    hand[0] = 6'b000000; // Rank 0 (2), Suit 0
    hand[1] = 6'b001001; // Rank 1 (3), Suit 1
    hand[2] = 6'b010010; // Rank 2 (4), Suit 2
    hand[3] = 6'b011011; // Rank 3 (5), Suit 3
    hand[4] = 6'b100000; // Rank 4 (6), Suit 0
    #10;
    $display("\n[TEST 1] High Card");
    display_hand();
    $display("Hand Rank Value: %0d", hand_rank_out);

    // Test Case 2: One Pair
    hand[0] = 6'b000000; // 2C
    hand[1] = 6'b000100; // 2H
    hand[2] = 6'b001001; // 3D
    hand[3] = 6'b010010; // 4H
    hand[4] = 6'b011011; // 5S
    #10;
    $display("\n[TEST 2] One Pair");
    display_hand();
    $display("Hand Rank Value: %0d", hand_rank_out);

    // Test Case 3: Three of a Kind
    hand[0] = 6'b000000; // 2C
    hand[1] = 6'b000100; // 2H
    hand[2] = 6'b000011; // 2S
    hand[3] = 6'b001001; // 3D
    hand[4] = 6'b010010; // 4H
    #10;
    $display("\n[TEST 3] Three of a Kind");
    display_hand();
    $display("Hand Rank Value: %0d", hand_rank_out);

    // Test Case 4: Flush
    hand[0] = 6'b000000; // 2C
    hand[1] = 6'b001000; // 3C
    hand[2] = 6'b010000; // 4C
    hand[3] = 6'b011000; // 5C
    hand[4] = 6'b100000; // 6C
    #10;
    $display("\n[TEST 4] Flush");
    display_hand();
    $display("Hand Rank Value: %0d", hand_rank_out);

    // Test Case 5: Straight Flush
    hand[0] = 6'b000000; // 2C
    hand[1] = 6'b001000; // 3C
    hand[2] = 6'b010000; // 4C
    hand[3] = 6'b011000; // 5C
    hand[4] = 6'b100000; // 6C
    #10;
    $display("\n[TEST 5] Straight Flush");
    display_hand();
    $display("Hand Rank Value: %0d", hand_rank_out);

    // End simulation
    #20;
    $display("\nAll tests completed.");
    $finish;
  end

endmodule

