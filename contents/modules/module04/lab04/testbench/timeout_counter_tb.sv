//------------------------------------------------------------------------------
// File Name: timeout_counter_tb.sv
// Description:  Testbench for game_fsm_controller with timeout/error detectio
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

module test_game_fsm;

  // Inputs to DUT
  logic clk;
  logic rst_n;
  logic tbl_game_start;
  logic tbl_game_over;
  logic [5:0] cr_rdata;
  logic cr_ack;
  logic [3:0] hand_rank_out;
  logic rank_done;

  // Outputs from DUT
  logic mem_we;
  logic rank_enable;
  logic cmd_trigger;
  logic [5:0] stored_card;
  logic [2:0] state;
  logic [7:0] timeout_counter;
  logic error;

  // Instantiate DUT
  game_fsm_controller dut (
    .clk(clk),
    .rst_n(rst_n),
    .tbl_game_start(tbl_game_start),
    .tbl_game_over(tbl_game_over),
    .cr_rdata(cr_rdata),
    .cr_ack(cr_ack),
    .rank_done(rank_done),
    .hand_rank_out(hand_rank_out),
    .mem_we(mem_we),
    .rank_enable(rank_enable),
    .cmd_trigger(cmd_trigger),
    .stored_card(stored_card),
    .state(state),
    .timeout_counter(timeout_counter),
    .error(error)
  );

  // Clock generation
  initial clk = 0;
  always #5 clk = ~clk;

  // Waveform dump
initial begin
  $shm_open("waves.shm");
  $shm_probe("S", "test_game_fsm.state");
  $shm_probe("S", "test_game_fsm.tbl_game_start");
  $shm_probe("S", "test_game_fsm.tbl_game_over");
  $shm_probe("S", "test_game_fsm.dut.hand_full");
  $shm_probe("S", "test_game_fsm.rank_done");
  $shm_probe("S", "test_game_fsm.cr_ack");
  $shm_probe("S", "test_game_fsm.cmd_trigger");
end


  // Variables
  integer ack_cycles = 0;
  integer timeout;

  // Stimulus
  initial begin
    $display("Starting Player Interface Testbench\n");

    // Global timeout safeguard
    fork
      begin
        #1000;
        $display("[ERROR] Simulation timed out");
        $finish;
      end
    join_none;

    // Initialization
    rst_n = 0;
    tbl_game_start = 0;
    tbl_game_over = 0;
    cr_ack = 0;
    cr_rdata = 6'b0;
    hand_rank_out = 4'd7;
    rank_done = 0;

    #20;
    rst_n = 1;
    #10;

    // Start game
    tbl_game_start = 1;
    #10;
    tbl_game_start = 0;

    // Simulate receiving 5 cards
    repeat (5) begin
      @(posedge mem_we);
      cr_rdata = $urandom_range(0, 63);
      #10;
    end

    // Wait for rank_enable signal and pulse rank_done
    timeout = 0;
    while (!rank_enable && timeout < 20) begin
      @(posedge clk);
      timeout++;
    end
    if (!rank_enable) begin
      $display("[ERROR] rank_enable not asserted in time");
      $finish;
    end
    #5 rank_done = 1;
    #10 rank_done = 0;

    // Wait for command trigger and handle timeout
    timeout = 0;
    while (!cmd_trigger && timeout < 20) begin
      @(posedge clk);
      timeout++;
    end
    if (!cmd_trigger) begin
      $display("[ERROR] cmd_trigger not asserted in time");
      $finish;
    end

    ack_cycles = 0;
    while (!cr_ack && ack_cycles < 8) begin
      #10;
      ack_cycles++;
    end
    if (ack_cycles >= 8) begin
      $display("[ERROR] ACK not received within 8 cycles");
      #10;
      $finish;
    end

    // Simulate no ACK to test timeout handling
    repeat (10) begin
      #10;
    end

    // Send ACK late
    #5 cr_ack = 1;
    #10 cr_ack = 0;

    // End round signal
    #20 tbl_game_over = 1;
    #10 tbl_game_over = 0;

    #50;
    $display("FSM simulation completed.");
    $finish;
  end

endmodule
