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

  // Declare testbench signals
  logic clk;
  logic rst_n;
  logic we;
  logic [2:0] waddr;
  logic [5:0] card_in;
  logic hand_full;
  logic [5:0] hand [4:0];

  // Instantiate the DUT
  hand_memory dut (
    .clk(clk),
    .rst_n(rst_n),
    .we(we),
    .waddr(waddr),
    .card_in(card_in),
    .hand_full(hand_full),
    .hand(hand)
  );

  // TODO: Clock Generation
  // Tip: Use an `always` block to toggle clk every 5ns

  // TODO: Waveform Dump
  // Tip: Use $shm_open and $shm_probe for SimVision viewing

  // TODO: Reset Sequence
  //  - Set rst_n low for a few cycles
  //  - Set rst_n high and begin testing

  // TODO: Stimulus Block
  //  - Write 5 encoded cards using we, waddr, and card_in
  //  - Use @(negedge clk) to time the writes
  //  - Wait for hand_full to go high

  // TODO: Output Verification
  //  - Use $display to print each card from hand[]
  //  - Confirm the hand is sorted (optional)

  // TODO: End Simulation
  //  - Wait a few cycles then call $finish

endmodule