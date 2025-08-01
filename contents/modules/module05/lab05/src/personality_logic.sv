//------------------------------------------------------------------------------
// File Name: personality_logic.sv
// Description: Verilog file that maps hand rank to action/discard/raise based on personality.
// Author: <Student Name>
// Date: <Date>
// Version: 1.0
// Project: ChipMango Lab 05 - Digitally Representing Poker Cards
// License: ChipMango Confidential - For educational purposes only
//------------------------------------------------------------------------------
// Revision History:
//   v1.0 - 07/06/25: Initial file created with module template
//------------------------------------------------------------------------------

module personality_logic (
  input  logic [8:0] hand_rank_out,       // One-hot hand type
  input  logic [1:0] personality,         // 00 = Good, 01 = Bad, 10 = Bluff
  input  logic [7:0] bad_bluffness_level, // Configurable aggression level
  output logic [2:0] action,              // 000 = CHECK, 001 = BET, 010 = ALL-IN
  output logic [1:0] discard_count,       // 0 to 3
  output logic [1:0] raise_amount         // 0 = min bet, 3 = max raise
);

  logic [3:0] rank;

  // Decode one-hot rank into binary rank
  always_comb begin
    unique case (hand_rank_out)
      9'b000000001: rank = 0; // High Card
      9'b000000010: rank = 1; // One Pair
      9'b000000100: rank = 2; // Two Pair
      9'b000001000: rank = 3; // Three of a Kind
      9'b000010000: rank = 4; // Straight
      9'b000100000: rank = 5; // Flush
      9'b001000000: rank = 6; // Full House
      9'b010000000: rank = 7; // Four of a Kind
      9'b100000000: rank = 8; // Straight Flush
      default:       rank = 0;
    endcase
  end

  // Main behavior logic
  always_comb begin
    // Defaults
    action = 3'b000;
    discard_count = 0;
    raise_amount = 0;

    unique case (personality)
      2'b00: begin // Good
        if (rank >= 2) begin
          action = 3'b001;         // Bet
          raise_amount = 2;
        end else begin
          action = 3'b000;         // Check
        end
        discard_count = (rank < 2) ? 2 : 0;
      end

      2'b01: begin // Bad
        if (rank < bad_bluffness_level[2:0]) begin
          action = 3'b001;         // Random bet
          raise_amount = bad_bluffness_level[3:2];
        end else begin
          action = 3'b000;         // Check
        end
        discard_count = bad_bluffness_level[1:0];
      end

      2'b10: begin // Bluff
        action = (bad_bluffness_level[0]) ? 3'b010 : 3'b001; // All-In or Bet
        discard_count = 0;
        raise_amount = bad_bluffness_level[3:2];
      end

      default: begin
        action = 3'b000;
        discard_count = 0;
        raise_amount = 0;
      end
    endcase
  end

endmodule

