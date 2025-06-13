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

logic [2:0] rank [4:0];
logic [1:0] suit [4:0];

genvar i;
generate
    for (i = 0; i < 5; i++) begin
        assign rank[i] = hand[i][5:3];
        assign suit[i] = hand[i][1:0];
    end
endgenerate

// Placeholder: no evaluation logic implemented yet
assign hand_rank_out = 9'b0;

endmodule
