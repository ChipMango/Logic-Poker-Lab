 //------------------------------------------------------------------------------
// File Name: multiplexing_logic_tb.sv
// Description:  -
// Author: <Student Name>
// Date: <Date>
// Version: 1.0
// Project: ChipMango Lab 03 - Digitally Representing Poker Cards
// License: ChipMango Confidential - For educational purposes only
//------------------------------------------------------------------------------
// Revision History:
//   v1.0 - 06/06/25: Initial file created with module template
//------------------------------------------------------------------------------


module test_player_interface;

  logic clk;
  logic rst_n;
  logic tbl_game_start;
  logic [5:0] cr_rdata;
  logic cr_ack;
  wire  [2:0] cr_cmd;
  wire        cr_cmdvld;
  wire        cmd_done;
  wire  [7:0] cr_wdata;

  // Clock generation
  initial clk = 0;
  always #5 clk = ~clk;

  // DUT instantiation
  player_interface dut (
    .clk(clk),
    .rst_n(rst_n),
    .tbl_game_start(tbl_game_start),
    .cr_ack(cr_ack),
    .cr_rdata(cr_rdata),
    .cr_cmd(cr_cmd),
    .cr_cmdvld(cr_cmdvld),
    .cmd_done(cmd_done),
    .cr_wdata(cr_wdata)
  );


  // Waveform dump
  initial begin
    $shm_open("waves.shm");
    $shm_probe("ACMT");
  end


  // Global simulation timeout (hard stop after 20,000ns)
  initial begin
    #20000;
    $display("[FATAL] Global simulation timeout reached. Ending test.");
    $finish;
  end

  // Test sequence
  initial begin
    $display("Starting Player Interface Testbench");

    rst_n = 0;
    tbl_game_start = 0;
    cr_ack = 0;
    cr_rdata = 6'd0;

    #20;
    rst_n = 1;

    #10;
    tbl_game_start = 1;
    #10;
    tbl_game_start = 0;

    // Simulate dealer sending 5 cards
    repeat (5) begin
      wait (dut.store_card);
      cr_rdata = $urandom_range(0, 63);
      cr_ack = 1;
      #10;
      cr_ack = 0;
      #10;
    end

    // Wait for GET_STATS phase and simulate pot size with timeout
    fork
      begin
        wait (cr_cmd == 3'b110 && cr_cmdvld);
        $display("[INFO] Get Stats command issued. Responding with pot size.");
        $display("[DEBUG] cr_cmd = %b, cr_cmdvld = %b at %0t", cr_cmd, cr_cmdvld, $time);
        #5 cr_ack = 1;
        #10;
        cr_rdata = 6'd55; // Pot size to simulate
        #10;
        cr_ack = 0;
      end
      begin
        repeat (500) @(posedge clk);
        $display("[ERROR] Timeout waiting for Get Stats command!");
        $finish;
      end
    join_any
    disable fork;

    // Wait for FSM to complete
    wait (cmd_done);
    $display("[DEBUG] cmd_done = %b at %0t", cmd_done, $time);
    repeat (100) @(posedge clk);

    $display("Simulation completed.");
    $finish;
  end

endmodule
