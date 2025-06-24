//------------------------------------------------------------------------------
// File Name: test_smoke_test.sv
// Description:This testbench is designed to run a basic smoke test simulation, ensuring that the simulation environment is set up correctly.
 // Author: <Student Name>
// Date: <Date>
// Version: 1.0
// Project: ChipMango Lab 00 - Digitally Representing Poker Cards
// License: ChipMango Confidential - For educational purposes only
//------------------------------------------------------------------------------
// Revision History:
//   v1.0 - 13/06/25: Initial file created with module template
//------------------------------------------------------------------------------


module test_poker_player;

  // Declare interface signals
  logic clk;
  logic rst_n;
  logic cr_cmdvld;
  logic [2:0] cr_cmd;
  logic cr_ack;
  logic [2:0] act_action;
  logic act_ready;

  // Instantiate the DUT (Device Under Test)
  poker_player dut (
    .clk(clk),
    .rst_n(rst_n),
    .cr_cmdvld(cr_cmdvld),
    .cr_cmd(cr_cmd),
    .cr_ack(cr_ack),
    .act_action(act_action),
    .act_ready(act_ready)
  );

  // Clock generation (100 MHz -> 10 ns period)
  always #5 clk = ~clk;

  // Waveform dump
  initial begin
    $shm_open("waves.shm");
    $shm_probe("ACMT");
  end

  // Simulation sequence
  initial begin
    $display("[TEST] Module 0 - Poker Player Placeholder Logic\n");

    // Initialize signals
    clk = 0;
    rst_n = 0;
    cr_cmdvld = 0;
    cr_cmd = 3'b000;

    // Apply reset
    #10 rst_n = 1;
    $display("[INFO] Reset deasserted\n");

    // Simulate Dealer command 1
    #10 cr_cmdvld = 1; cr_cmd = 3'b001;
    #10 cr_cmdvld = 0;
    $display("[INFO] Dealer sent command 001\n");
    $display("[STATE] act_action = %b, act_ready = %b, cr_ack = %b", act_action, act_ready, cr_ack);

    // Simulate Dealer command 3
    #10 cr_cmdvld = 1; cr_cmd = 3'b011;
    #10 cr_cmdvld = 0;
    $display("[INFO] Dealer sent command 011\n");
    $display("[STATE] act_action = %b, act_ready = %b, cr_ack = %b", act_action, act_ready, cr_ack);

    #50 $display("[TEST] Placeholder interaction complete.\n");
    $finish;
  end

endmodule
