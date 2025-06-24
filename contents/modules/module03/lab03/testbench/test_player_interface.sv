
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

module test_player_interface;

  logic clk;
  logic rst_n;
  logic trigger;
  logic [2:0] action_code;
  logic cr_ack;
  logic [7:0] cr_rdata;
  logic [2:0] cr_cmd;
  logic cr_cmdvld;
  logic cmd_done;
  logic [7:0] cr_wdata;

  // Clock generation
  initial clk = 0;
  always #5 clk = ~clk; // 100MHz clock

  // Instantiate the DUT
  player_interface uut (
    .clk(clk),
    .rst_n(rst_n),
    .trigger(trigger),
    .action_code(action_code),
    .cr_ack(cr_ack),
    .cr_rdata(cr_rdata),
    .cr_cmd(cr_cmd),
    .cr_cmdvld(cr_cmdvld),
    .cmd_done(cmd_done),
    .cr_wdata(cr_wdata)
  );

  // Simulated dealer response task
  task simulate_ack_response;
    begin
      #10 cr_ack = 1;
      #10 cr_ack = 0;
    end
  endtask

  initial begin
    $display("Starting Player Interface Testbench");
    $shm_open("waves.shm");
    $shm_probe("ACMT");

    // Initialize
    rst_n = 0;
    trigger = 0;
    action_code = 3'b000;
    cr_ack = 0;
    cr_rdata = 8'b0;

    #20 rst_n = 1;

    // Simulate receiving 5 cards (command 000: Issue Exchange Card or Report Holding)
    for (int i = 0; i < 5; i++) begin	  
      action_code = 3'b000;
      trigger = 1;
      cr_rdata = {2'b00, i[5:0]}; // Dummy card values
      #10 trigger = 0;
      simulate_ack_response();
      #20;

    end

    // Simulate receiving 5 cards (command 100: Get Card)
    action_code = 3'b100;
    trigger = 1;
    #10 trigger = 0;
    simulate_ack_response();
    #10;

    // Issue Get Stats (110)
    action_code = 3'b110;
    trigger = 1;
    #10 trigger = 0;
    simulate_ack_response();
    #20;

    // Issue Check (001)
    action_code = 3'b001;
    trigger = 1;
    #10 trigger = 0;
    simulate_ack_response();
    #20;

    // Issue Bet/Raise (010)
    action_code = 3'b010;
    trigger = 1;
    #10 trigger = 0;
    simulate_ack_response();
    #20;

    // Issue All-In (011)
    action_code = 3'b011;
    trigger = 1;
    #10 trigger = 0;
    simulate_ack_response();
    #20;

    $display("Test complete.");
    $finish;
  end

endmodule


