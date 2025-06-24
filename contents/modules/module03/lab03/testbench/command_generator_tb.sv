//------------------------------------------------------------------------------
// File Name: command_generator_tb.sv
// Description:  Testbench 
// Author: <Student Name>
// Date: <Date>
// Version: 1.0
// Project: ChipMango Lab 03 - Digitally Representing Poker Cards
// License: ChipMango Confidential - For educational purposes only
//------------------------------------------------------------------------------
// Revision History:
//   v1.0 - 07/06/25: Initial file created with module template
//------------------------------------------------------------------------------

 module unit_test_command_gen;

  logic clk;
  logic rst_n;
  logic [2:0] action_code;
  logic trigger;
  logic [2:0] cr_cmd;
  logic cr_cmdvld;
  logic cr_ack;
  logic cmd_done;

  // Clock generation
  initial clk = 0;
  always #5 clk = ~clk;

  // Instantiate DUT
  command_generator dut (
    .clk(clk),
    .rst_n(rst_n),
    .action_code(action_code),
    .trigger(trigger),
    .cr_cmd(cr_cmd),
    .cr_cmdvld(cr_cmdvld),
    .cr_ack(cr_ack),
    .cmd_done(cmd_done)
  );

  // Stimulus
  initial begin
    $display("Starting Command Generator Unit Test...");

    rst_n = 0;
    trigger = 0;
    cr_ack = 0;
    action_code = 3'b000;

    #20 rst_n = 1;

    // Test All Commands
    foreach (action_code[i]) begin
      send_command(i);
    end

    $display("\nAll commands tested.");
    #20;
    $finish;
  end

  task send_command(input [2:0] cmd);
    begin
      action_code = cmd;
      trigger = 1;
      #10 trigger = 0;
      #10 cr_ack = 1;
      #10 cr_ack = 0;
      wait (cmd_done);
      #10;
      $display("Command %b completed", cmd);
    end
  endtask

endmodule

