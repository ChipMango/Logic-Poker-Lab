//------------------------------------------------------------------------------
// File Name:files.f
// Description: Simulation setup file for running the testbench.
// Author: <Student Name>
// Date: <Date>
// Version: 1.0
// Project: ChipMango Lab 01 - Digitally Representing Poker Cards
// License: ChipMango Confidential - For educational purposes only
//------------------------------------------------------------------------------
// Revision History:
//   v1.0 - 06/06/25: Initial file created with module template
//------------------------------------------------------------------------------


# files.f for Module 2: Hand Ranking Engine

../src/hand_rank_evaluator.sv  # Source file for Hand Ranking Evaluator
../src/rank_encoding.sv
../testbench/test_hand_rank_evaluator.sv  # Testbench for Hand Ranking Evaluator
../testbench/rank_encoding_tb.sv

//+define+TEST_HAND_RANK_EVALUATOR
//+define+TEST_RANK_ENCODING_TB
//-access +rwc
