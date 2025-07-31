// File Name: bubble_sort_tb.sv
// Author: <Student Name>
// Date: <Date>
// Version: 1.0
// Project: ChipMango Lab 02 - Digitally Representing Poker Cards
// License: ChipMango Confidential - For educational purposes only
//------------------------------------------------------------------------------
// Revision History:
//   v1.0 - 06/06/25: Initial file created with module template
//------------------------------------------------------------------------------ 

module hand_rank_evaluator (
  input  logic        clk,
  input  logic        rst_n,
  input  logic [5:0]  hand [4:0],     // 5 encoded cards (6-bit each)
  output logic [8:0]  hand_rank_out,  // One-hot rank result
  output logic        rank_done       // Rank evaluation done flag
);

  // Internal signals
  logic [3:0] rank_count [0:12];     // 13 possible ranks (2–Ace)
  logic [2:0] suit_count [0:3];      // 4 suits
  logic [2:0] rank, max_same_rank;
  logic [1:0] suit;
  logic is_flush, is_straight, is_four, is_full, is_three, is_two_pair, is_one_pair;
  int pairs;  

  logic [8:0] hand_rank_comb;

  always_comb begin
    pairs = 0; // reset pair count

    // Clear counters
    foreach (rank_count[i]) rank_count[i] = 0;
    foreach (suit_count[i]) suit_count[i] = 0;

    // Count ranks and suits
    foreach (hand[i]) begin
      rank = hand[i][5:3];  // Top 3 bits = rank
      suit = hand[i][2:1];  // Next 2 bits = suit
      rank_count[rank] += 1;
      suit_count[suit] += 1;
    end

    // Detect flush
    is_flush = 0;
    foreach (suit_count[i])
      if (suit_count[i] == 5)
        is_flush = 1;

    // Detect straight
    is_straight = 0;
    for (int i = 0; i <= 8; i++) begin
      if (rank_count[i]   >= 1 &&
          rank_count[i+1] >= 1 &&
          rank_count[i+2] >= 1 &&
          rank_count[i+3] >= 1 &&
          rank_count[i+4] >= 1)
        is_straight = 1;
    end

    // Detect combinations
    is_four = 0;
    is_three = 0;
    foreach (rank_count[i]) begin
      case (rank_count[i])
        4: is_four = 1;
        3: is_three = 1;
        2: pairs++;
      endcase
    end

    is_full     = (is_three && pairs >= 1);
    is_two_pair = (pairs == 2);
    is_one_pair = (pairs == 1);

    // Default: High Card
    hand_rank_comb = 9'b000000001;

    if (is_flush && is_straight) hand_rank_comb = 9'b100000000;
    else if (is_four)            hand_rank_comb = 9'b010000000;
    else if (is_full)            hand_rank_comb = 9'b001000000;
    else if (is_flush)           hand_rank_comb = 9'b000100000;
    else if (is_straight)        hand_rank_comb = 9'b000010000;
    else if (is_three)           hand_rank_comb = 9'b000001000;
    else if (is_two_pair)        hand_rank_comb = 9'b000000100;
    else if (is_one_pair)        hand_rank_comb = 9'b000000010;
  end

  // Sync output and rank_done flag
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      hand_rank_out <= 9'd0;
      rank_done <= 1'b0;
    end else begin
      hand_rank_out <= hand_rank_comb;
      rank_done <= 1'b1;  // Always ready next cycle
    end
  end

  // Debug print
  always_ff @(posedge clk) begin
    $display("Hand Rank Evaluator: hand=%p, hand_rank_out=%0b", hand, hand_rank_out);
  end

endmodule

