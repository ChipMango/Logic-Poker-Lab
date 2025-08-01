//------------------------------------------------------------------------------
// File Name: command_generator.sv
// Description:   module that implements the handshke and command generation.
// Author: <Student Name>
// Date: <Date>
// Version: 1.0
// Project: ChipMango Lab 03 - Digitally Representing Poker Cards
// License: ChipMango Confidential - For educational purposes only
//------------------------------------------------------------------------------
// Revision History:
//   v1.0 - 07/06/25: Initial file created with module template
//------------------------------------------------------------------------------


module command_generator (
  input  logic        clk,
  input  logic        rst_n,
  input  logic [2:0]  action_code,      // Command to send
  input  logic        trigger,          // Pulse to initiate command
  output logic [2:0]  cr_cmd,           // 3-bit command to Dealer
  output logic        cr_cmdvld,        // Command valid output to Dealer
  input  logic        cr_ack,           // Acknowledge from Dealer
  output logic        cmd_done          // Pulses high when Dealer acknowledges command
);

  // FSM States
  typedef enum logic [1:0] {
    IDLE,
    SEND_CMD,
    WAIT_ACK
  } state_t;

  state_t state, next_state;

  // Internal register to store command
  logic [2:0] latched_cmd;

  // FSM: State Transitions
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n)
      state <= IDLE;
    else
      state <= next_state;
  end

  // FSM: Next State Logic
  always_comb begin
    next_state = state;
    case (state)
      IDLE: begin
        if (trigger)
          next_state = SEND_CMD;
      end
      SEND_CMD: begin
        next_state = WAIT_ACK;
      end
      WAIT_ACK: begin
        if (cr_ack)
          next_state = IDLE;
      end
    endcase
   end

always_ff @(posedge clk) begin
  $display("Cmd Gen: cmd_trigger=%b action_code=%b cr_cmdvld=%b cr_cmd=%b",
           trigger, action_code, cr_cmdvld, cr_cmd);
end
    

  // Latch command on trigger
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n)
      latched_cmd <= 3'b000;
    else if (trigger && state == IDLE)
      latched_cmd <= action_code;
  end

  // Outputs
  assign cr_cmd = latched_cmd;

  always_comb begin
    cr_cmdvld = 0;
    cmd_done  = 0;
    case (state)
      SEND_CMD: begin
        cr_cmdvld = 1;
      end
      WAIT_ACK: begin
        cr_cmdvld = 1;
        if (cr_ack)
          cmd_done = 1;
      end
    endcase
  end

endmodule

