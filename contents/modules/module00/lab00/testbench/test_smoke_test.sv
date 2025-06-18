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


module test_smoke_test;

  // Declare the signals
  logic clk;
  logic rst_n;
  logic tbl_game_start;
  logic cr_cmdvld;
  logic [2:0] cr_cmd;
  logic cr_ack;

  // Waveform dump
  initial begin
    $shm_open("waves.shm");
    $shm_probe("ACMT");
  end

  // Define a string variable for the player type
  string player_type;

 // Conditional logic based on the define flag
  `ifdef PLAYER
    initial begin
      player_type = "student";  // Set to 'student' if PLAYER is defined
      $display("Running simulation for player: %s", player_type);   
    end
  `else
    initial begin
      player_type = "default";
      $display("Running simulation for default player");
    end
  `endif

  // Instantiate the top-level module (poker_player)
  poker_player uut (
    .clk(clk),
    .rst_n(rst_n),
    .tbl_game_start(tbl_game_start),
    .cr_cmdvld(cr_cmdvld),
    .cr_cmd(cr_cmd),
    .cr_ack(cr_ack)
  );

  // Generate clock signal (period of 10ns, 100MHz)
  always #5 clk = ~clk;

  initial begin
    // Initialize signals
    clk = 0;
    rst_n = 0;
    tbl_game_start = 0;
    cr_ack = 0;

    // Apply reset
    #10 rst_n = 1;
    
    // Start the game after reset
    #10 tbl_game_start = 1;
    
    // Check outputs
    #10;
    $display("cr_cmdvld: %b, cr_cmd: %b", cr_cmdvld, cr_cmd);
    
    // End simulation
    #100 $finish;
  end

endmodule
