//------------------------------------------------------------------------------
// File Name: test_player_interface.sv
// Description:  Testbench for simulating the player interface and verifying the handshake and command transactions.
// Author: <Student Name>
// Date: <Date>
// Version: 1.0
// Project: ChipMango Lab 03 - Digitally Representing Poker Cards
// License: ChipMango Confidential - For educational purposes only
//------------------------------------------------------------------------------
// Revision History:
//   v1.0 - 07/06/25: Initial file created with module template
//------------------------------------------------------------------------------

module player_interface_tb;

  // DUT signals
  logic clk;
  logic rst_n;
  logic tbl_game_start;
  logic cr_ack;
  logic [5:0] cr_rdata;
  logic [2:0] cr_cmd;
  logic cr_cmdvld;
  logic cmd_done;
  logic [5:0] cr_wdata;
  logic [5:0] card_hand [4:0];

  logic [3:0] state;
  assign state = player_interface_tb.dut.state;

  // Instantiate DUT
  player_interface dut (
    .clk(clk),
    .rst_n(rst_n),
    .tbl_game_start(tbl_game_start),
    .cr_ack(cr_ack),
    .cr_rdata(cr_rdata),
    .cr_cmd(cr_cmd),
    .cr_cmdvld(cr_cmdvld),
    .cmd_done(cmd_done),
    .cr_wdata(cr_wdata),
    .card_hand(card_hand)
  );

  // Clock generation
  always #5 clk = ~clk;

// Waveform dump
  initial begin
    $shm_open("waves.shm");
    $shm_probe("ACMT");
  end

   // --- Add debug prints here ---

  // Print when cr_cmdvld asserts
  always @(posedge clk) begin
    if (cr_cmdvld) 
      $display("cr_cmdvld asserted at time %t", $time);
  end

  // Monitor tbl_game_start pulses
  initial begin
    $monitor("tbl_game_start = %b at time %t", tbl_game_start, $time);
  end

  // Display FSM state every clock
  always @(posedge clk) begin
    $display("FSM State: %0d at time %t", state, $time);
  end

  // Print cr_cmd value when valid
  always @(posedge clk) begin
    if (cr_cmdvld)
      $display("cr_cmd = %b at time %t", cr_cmd, $time);
  end

  // Dealer card data simulation
  logic [5:0] deck [4:0] = '{6'd3, 6'd12, 6'd25, 6'd7, 6'd19};
  int card_response_index = 0;

  // Simulate the dealer's behavior
  task simulate_dealer();
    repeat (5) begin
      wait (cr_cmdvld && cr_cmd == 3'b001); // Wait for card request
      #1;
      cr_rdata = deck[card_response_index];
      cr_ack = 1;
      #10;
      cr_ack = 0;
      card_response_index++;
    end
  endtask

  // Simulate command done signal for FSM progress
  task simulate_cmd_done();
    forever begin
      @(posedge clk);
      if (cr_cmdvld) begin
        #1;
        cmd_done = 1;
        @(posedge clk);
        cmd_done = 0;
      end
    end
  endtask

  // Wait until FSM returns to IDLE after one full round, with timeout
  task wait_for_idle_with_timeout();
    static int cycles = 0;
    static int TIMEOUT = 2000;
    // Wait for state to leave IDLE (game start)
    wait (state != 4'd0);
    cycles = 0;
    // Wait for state to return to IDLE
    while (state != 4'd0 && cycles < TIMEOUT) begin
      @(posedge clk);
      cycles++;
    end
    if (state != 4'd0) begin
      $fatal(1, "Timeout: FSM did not return to IDLE after full round.");
    end
  endtask

  // Main stimulus
  initial begin
    $display("=== Starting Player Interface Test ===");
    clk = 0;
    rst_n = 0;
    tbl_game_start = 0;
    cr_ack = 0;
    cr_rdata = 6'd0;
    cmd_done = 0;
    #20;
    rst_n = 1;

    // Start the game
    #10;
    tbl_game_start = 1;
    #10;
    tbl_game_start = 0;

    fork
      simulate_dealer();
      simulate_cmd_done();
    join_none

    wait_for_idle_with_timeout();

    $display("=== Final Hand ===");
    foreach (card_hand[i])
      $display("Card[%0d] = %0d", i, card_hand[i]);

    $display("cr_wdata (hand_rank_out encoded/truncated): %0d", cr_wdata);
    $display("=== Test Completed ===");
    $finish;
  end

endmodule

