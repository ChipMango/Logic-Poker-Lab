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
  input  logic [8:0] hand_rank_out,   // One-hot hand type
  input  logic [1:0] personality,     // 00 = Good, 01 = Bad, 10 = Bluff
  output logic [2:0] action,          // 000 = CHECK, 001 = BET, 010 = ALL-IN
  output logic [1:0] discard_count,   // 0 to 3 cards
  output logic [1:0] raise_amount     // 0 = min bet, 3 = max raise
);
