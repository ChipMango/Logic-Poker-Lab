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

  logic        clk;
  logic        rst_n;
  logic        we;
  logic [2:0]  waddr;
  logic [5:0]  card_in;
  logic        hand_full;

  // Instantiate the DUT
  hand_memory dut (
    .clk       (clk),
    .rst_n     (rst_n),
    .we        (we),
    .waddr     (waddr),
    .card_in   (card_in),
    .hand_full (hand_full)
  );

  // Generate a 10ns clock
  always #5 clk = ~clk;

  initial begin
    $display("\n--- Running Module 1: test_hand_memory ---");

    // Initialize signals
    clk      = 0;
    rst_n    = 0;
    we       = 0;
    waddr    = 3'b000;
    card_in  = 6'b000000;

    // Apply reset
    #10;
    rst_n = 1;
    #10;

    // Write 5 cards into memory
    for (int i = 0; i < 5; i++) begin
      we      = 1;
      waddr   = i[2:0];
      card_in = i + 6; // Arbitrary card values
      #10;
    end

    we = 0; // Stop writing
    #10;

    // Check if hand_full is asserted
    if (hand_full) begin
      $display("✅ PASS: hand_full correctly asserted after 5 cards.");
    end else begin
      $display("❌ FAIL: hand_full was not asserted.");
    end

    // Optional: Check reset behavior
    rst_n = 0;
    #10;
    rst_n = 1;
    #10;

    if (!hand_full) begin
      $display("✅ PASS: hand_full cleared after reset.");
    end else begin
      $display("❌ FAIL: hand_full not cleared after reset.");
    end

    $display("--- End of test_hand_memory ---\n");
    $finish;
  end

endmodule

