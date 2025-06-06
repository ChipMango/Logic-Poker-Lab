
//------------------------------------------------------------------------------
// File Name:hand_rank_evaluator.sv
// Description:  implements the hand ranking evaluator logic.
// Author: <Student Name>
// Date: <Date>
// Version: 1.0
// Project: ChipMango Lab 01 - Digitally Representing Poker Cards
// License: ChipMango Confidential - For educational purposes only
//------------------------------------------------------------------------------
// Revision History:
//   v1.0 - 06/06/25: Initial file created with module template
//------------------------------------------------------------------------------


module hand_rank_evaluator (
    input  logic [5:0] hand [4:0],      // 5 encoded cards
    output logic [8:0] hand_rank_out    // One-hot rank output
);

// Use bit slicing to extract rank and suit from each card:

logic [2:0] rank = hand[i][5:3];
logic [1:0] suit = hand[i][2:1];
