 //------------------------------------------------------------------------------
// File Name:rank_encoding.sv
// Description:  - 
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
  input  logic [5:0] hand [4:0],       // Input: 5 encoded cards (6-bit each)
  output logic [3:0] hand_rank_out   // Output: 4-bit hand rank (0–8)
);

  // Temporary variables
  logic [2:0] rank [4:0];         // Extracted rank of each card (0–12)
  logic [1:0] suit [4:0];         // Extracted suit of each card (0–3)

  logic [3:0] rank_count [0:12];  // Count of each rank (0–12 for 2–Ace)
  logic [2:0] suit_count [0:3];   // Count of each suit (0–3 for Clubs–Spades)

  logic is_flush;
  logic is_straight;
  logic [3:0] max_rank_repeat;   // Max # of same rank (2, 3, 4)
  logic pair_found, two_pair, three_kind, four_kind, full_house;
  int pair_count;  // Declare here instead of inside always_comb


  // -------------------------------
  // 1. Extract rank and suit
  //  -------------------------------
  always_comb begin
    for (int i = 0; i < 5; i++) begin
      rank[i] = hand[i][5:3];
      suit[i] = hand[i][2:1];
    end
  end

  // -------------------------------
  // 2. Initialize counters
  // -------------------------------
  always_comb begin
    // Reset counts
    
    for (int i = 0; i < 13; i++) rank_count[i] = 0;
    for (int i = 0; i < 4; i++)  suit_count[i] = 0;

    // Count ranks and suits
    for (int i = 0; i < 5; i++) begin
      rank_count[rank[i]]++;
      suit_count[suit[i]]++;
    end
  end

  // -------------------------------
  // 3. Detect flush (any suit count == 5)
  // -------------------------------
  always_comb begin
    is_flush = 0;
    for (int i = 0; i < 4; i++) begin
      if (suit_count[i] == 5)
        is_flush = 1;
    end
  end

  // -------------------------------
  // 4. Detect straight (5 consecutive non-zero ranks)
  // -------------------------------
  always_comb begin
    is_straight = 0;
    for (int i = 0; i <= 8; i++) begin
      if (rank_count[i]   > 0 &&
          rank_count[i+1] > 0 &&
          rank_count[i+2] > 0 &&
          rank_count[i+3] > 0 &&
          rank_count[i+4] > 0)
        is_straight = 1;
    end
  end

  // -------------------------------
  // 5. Rank-based hand analysis
  // -------------------------------
  always_comb begin
    pair_count = 0; // initialize inside the block
    max_rank_repeat = 0;
    pair_found = 0;
    two_pair = 0;
    three_kind = 0;
    four_kind = 0;
    full_house = 0;

    for (int i = 0; i < 13; i++) begin
      if (rank_count[i] > max_rank_repeat)
        max_rank_repeat = rank_count[i];

      case (rank_count[i])
        2: pair_count++;
        3: three_kind = 1;
        4: four_kind = 1;
      endcase
    end

    if (pair_count == 1) pair_found = 1;
    if (pair_count == 2) two_pair = 1;
    if (three_kind && pair_count >= 1) full_house = 1;
  end

  // -------------------------------
  // 6. Priority Assignment to hand_rank_out
  // -------------------------------
  always_comb begin
    hand_rank_out = 4'd0; // Default = High Card

    if (is_flush && is_straight) hand_rank_out = 4'd8; // Straight Flush
    else if (four_kind)          hand_rank_out = 4'd7; // Four of a Kind
    else if (full_house)         hand_rank_out = 4'd6; // Full House
    else if (is_flush)           hand_rank_out = 4'd5; // Flush
    else if (is_straight)        hand_rank_out = 4'd4; // Straight
    else if (three_kind)         hand_rank_out = 4'd3; // Three of a Kind
    else if (two_pair)           hand_rank_out = 4'd2; // Two Pair
    else if (pair_found)         hand_rank_out = 4'd1; // One Pair
    else                         hand_rank_out = 4'd0; // High Card
  end

endmodule
