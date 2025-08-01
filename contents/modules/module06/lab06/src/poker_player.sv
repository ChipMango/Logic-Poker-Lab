
//------------------------------------------------------------------------------
// File Name: poker_player.sv
// Description: The top-level module that integrates all submodules.
// Author: <Student Name>
// Date: <Date>
// Version: 1.0
// Project: ChipMango Lab 06 - Digitally Representing Poker Cards
// License: ChipMango Confidential - For educational purposes only
//------------------------------------------------------------------------------
// Revision History:
//   v1.0 - 08/06/25: Initial file created with module template

module poker_player (
  input  logic        clk,
  input  logic        rst_n,

  // Game control
  input  logic        tbl_game_start,
  input  logic        tbl_game_over,

  // Command interface
  output logic        cr_cmdvld,
  output logic [2:0]  cr_cmd,
  input  logic        cr_ack,
  output logic [5:0]  cr_wdata,
  input  logic [7:0]  cr_rdata,
  input  logic        cr_rdatavld,

  // Output
  output logic [8:0]  hand_rank_out
);

  // Internal signals
  logic [5:0] hand [4:0];
  logic [8:0] hand_rank;
  logic [1:0] personality;
  logic [2:0] action;
  logic [1:0] discard_count;
  logic [1:0] raise_amount;

  // FSM control signals
  logic        mem_we;
  logic        rank_enable;
  logic        cmd_trigger;
  logic [5:0]  stored_card;
  logic [2:0]  state;
  logic        rank_done;
  logic        hand_full;
  logic        cmd_done;

  // Address for hand_memory write
  logic [2:0]  card_index;

  // Assign output
  assign hand_rank_out = hand_rank;
  assign personality = 2'b10; // BLUFF example

  // Instantiate FSM controller
  game_fsm_controller u_fsm (
    .clk(clk),
    .rst_n(rst_n),
    .tbl_game_start(tbl_game_start),
    .tbl_game_over(tbl_game_over),
    .cr_rdata(cr_rdata),
    .cr_ack(cr_ack),
    .rank_done(rank_done),
    .hand_rank_out(hand_rank),
    .mem_we(mem_we),
    .rank_enable(rank_enable),
    .cmd_trigger(cmd_trigger),
    .stored_card(stored_card),
    .state(state),
    .hand_full(hand_full)  // **No internal assignment in top module!**
  );

  // Instantiate hand memory
  hand_memory u_hand_mem (
    .clk(clk),
    .rst_n(rst_n),
    .we(mem_we),
    .waddr(card_index),
    .card_in(stored_card),
    .hand_full(hand_full),  // Driven inside hand_memory only
    .hand(hand)
  );

  // To hand_rank_evaluator
hand_rank_evaluator u_rank_eval(
  .clk(clk),
  .rst_n(rst_n),
  .hand(hand),
  .hand_rank_out(hand_rank),
  .rank_done(rank_done)
);
  // Personality logic
  personality_logic u_personality (
    .hand_rank_out(hand_rank),
    .personality(personality),
    .bad_bluffness_level(8'b10001100),
    .action(action),
    .discard_count(discard_count),
    .raise_amount(raise_amount)
  );

  // --- Instantiate player_interface here ---
  player_interface u_player_if (
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

  // card_index increments on mem_we, reset on rst or game start
always_ff @(posedge clk or negedge rst_n) begin
  if (!rst_n)
    card_index <= 0;
  else if (tbl_game_start)
    card_index <= 0;
  else if (mem_we)
    card_index <= (card_index == 3'd4) ? 3'd4 : card_index + 1;
    $display("Poker Player: mem_we=%b, stored_card=0x%02h", mem_we, stored_card);
end

  // Monitor memory write and FSM related signals
always_ff @(posedge clk) begin
  $display("Time=%0t | mem_we=%b | cmd_trigger=%b | stored_card=0x%02h | card_index=%0d | hand_full=%b",
            $time, mem_we, cmd_trigger, stored_card, card_index, hand_full);
end

// Monitor personality and command signals
always_ff @(posedge clk) begin
  $display("Time=%0t | action=%0d | discard_count=%0d | raise_amount=%0d",
            $time, action, discard_count, raise_amount);
end

// Monitor command generation outputs
always_ff @(posedge clk) begin
  $display("Time=%0t | cr_cmdvld=%b | cr_cmd=%b | cr_wdata=0x%02h | hand_rank=%0d",
            $time, cr_cmdvld, cr_cmd, cr_wdata, hand_rank_out);
end

endmodule

