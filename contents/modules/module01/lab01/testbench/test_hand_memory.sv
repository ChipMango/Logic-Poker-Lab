//------------------------------------------------------------------------------
// File Name: test_hand_memory.sv
// Description:  Testbench to simulate the memory block and verify the hand loading behavior.
// Author: <Student Name>
// Date: <Date>
// Version: 1.0
// Project: ChipMango Lab 01 - Digitally Representing Poker Cards
// License: ChipMango Confidential - For educational purposes only
//------------------------------------------------------------------------------
// Revision History:
//   v1.0 - 06/06/25: Initial file created with module template
//------------------------------------------------------------------------------

`timescale 1ns/1ps

module test_hand_memory;

  // Declare the signals
  logic clk;
  logic rst_n;
  logic we;
  logic [2:0] waddr;
  logic [5:0] card_in;
  logic hand_full;
  logic [5:0] hand [4:0];  // The output array for the 5 cards

  // Instantiate the hand_memory module
  hand_memory dut (
    .clk(clk),
    .rst_n(rst_n),
    .we(we),
    .waddr(waddr),
    .card_in(card_in),
    .hand_full(hand_full),
    .hand(hand)
  );

  // Generate clock signal (100 MHz clock with a period of 10 ns)
  always #5 clk = ~clk;

 // Waveform dump
  initial begin
    $shm_open("waves.shm");
    $shm_probe("ACMT");
  end

  //Test sequence
  initial begin
    // Initialize signals; Reset and wait
    clk = 0;
    rst_n = 0;
    we = 0;
    waddr = 3'b000;
    card_in = 6'b000000;  // Initial card input (arbitrary 6-bit value)


     // Apply reset
    #10 rst_n = 1; // Release reset after 10 ns

    // Simulate writing 5 cards into memory; first 4 bits represent the rank
    // and last 2 bits represent the suit
   
    for (int i = 0; i < 5; i++) begin
      @(negedge clk);
      we = 1;
      waddr = i;
      case (i)
      	0: #10 card_in = 6'b011001;  // Write first card: Rank 6, Suit 1
      	1: #10 card_in = 6'b001111;  // Write second card: Rank 3, Suit 3
      	2: #10 card_in = 6'b010100;  // Write third card: Rank 5, Suit 0
      	3: #10 card_in = 6'b000110;  // Write fourth card: Rank 1, Suit 2
      	4: #10 card_in = 6'b100000; // Write fifth card: Rank 8, Suit 0
      endcase
    end

    // Finish the simulation after all 5 cards are written
    @(negedge clk);
    #10 we = 0;  // Disable write enable

    // Wait for sort
    wait (hand_full);

    // Check the results
    #10 $display("hand_full: %b", hand_full);  // Expect hand_full to be 1
    $display("hand[0]: %b, hand[1]: %b, hand[2]: %b, hand[3]: %b, hand[4]: %b", hand[0], hand[1], hand[2], hand[3], hand[4]);

    // End the simulation
    #20 $finish;
  end

endmodule
