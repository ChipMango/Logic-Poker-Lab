//------------------------------------------------------------------------------
// File Name: test_game_fsm.sv
// Description: Testbench for simulating the FSM and verifying the state transitions and game flow.
// Author: <Student Name>
// Date: <Date>
// Version: 1.0
// Project: ChipMango Lab 04 - Digitally Representing Poker Cards
// License: ChipMango Confidential - For educational purposes only
//------------------------------------------------------------------------------
// Revision History:
//   v1.0 - 07/06/25: Initial file created with module template
//------------------------------------------------------------------------------

module test_game_fsm;

  logic clk;
  logic rst_n;
  logic tbl_game_start;
  logic tbl_game_over;
  logic [5:0] cr_rdata;
  logic cr_ack;
  logic rank_done;
  logic [3:0] hand_rank_out;

  logic mem_we;
  logic rank_enable;
  logic cmd_trigger;
  logic [5:0] stored_card;
  logic [2:0] state;

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
    .state(state)
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


  // Initial test sequence
  initial begin
    $display("Starting FSM Testbench...");
    clk = 0;
    rst_n = 0;
    tbl_game_start = 0;
    tbl_game_over = 0;
    cr_rdata = 6'b0;
    cr_ack = 0;
    hand_rank_out = 4'd6; // mid-rank for now

    #20 rst_n = 1;
    #10 tbl_game_start = 1;
    #10 tbl_game_start = 0;

    // Simulate Dealer sending 5 cards
    repeat (5) begin
      wait (dut.mem_we);
      cr_rdata = $urandom_range(0, 63);
      #10;
    end

    // Wait for rank_enable signal
    wait (rank_enable);
    #10;

    // Wait for command trigger
    wait (cmd_trigger);
    #5 cr_ack = 1;
    #10 cr_ack = 0;

    // End round signal
    #20 tbl_game_over = 1;
    #10 tbl_game_over = 0;

    #50;
    $display("FSM simulation completed.");
    $finish;
  end

  // Monitor outputs
  initial begin
    $shm_open("waves.shm");
    $shm_probe("ACMT");

    $display("\n===== Starting Full Game Round Simulation =====");
   // $monitor("@%0t | cr_cmdvld=%b cr_cmd=%b cr_ack=%b cmd_done=%b cr_wdata=%h", $time, cr_cmdvld, cr_cmd, cr_ack, cmd_done, cr_wdata);

      $monitor(“@%0t | cr_ack=%b”,$time, cr_ack);

    #500;
    $display("\n===== Simulation Complete =====");
    $finish;
  end

endmodule
