//------------------------------------------------------------------------------
// File Name: hand_memory.sv
// Description:   card memory block, implementing the register array and write logic.
// Author: <Student Name>
// Date: <Date>
// Version: 1.0
// Project: ChipMango Lab 01 - Digitally Representing Poker Cards
// License: ChipMango Confidential - For educational purposes only
//------------------------------------------------------------------------------
// Revision History:
//   v1.0 - 06/06/25: Initial file created with module template
//------------------------------------------------------------------------------


module hand_memory (
    input  logic        clk,
    input  logic        rst_n,
    input  logic        we,             // Write Enable
    input  logic [2:0]  waddr,          // 3-bit address: valid range 0–4
    input  logic [5:0]  card_in,        // Encoded card input
    output logic        hand_full,      // High when all 5 slots are filled
    output logic [5:0]  hand [4:0]      // The 5-card hand (array of outputs)
);
