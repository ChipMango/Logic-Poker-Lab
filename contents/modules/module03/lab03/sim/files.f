//------------------------------------------------------------------------------
// File Name: files.f
// Description: Simulation setup file for running the testbench
// Author: <Student Name>
// Date: <Date>
// Version: 1.0
// Project: ChipMango Lab 03 - Digitally Representing Poker Cards
// License: ChipMango Confidential - For educational purposes only
//------------------------------------------------------------------------------
// Revision History:
//   v1.0 - 07/06/25: Initial file created with module template
//------------------------------------------------------------------------------

# files.f for Module 3: Player Interface & Command Generator

../src/command_generator.sv    # Command Generator module
../src/multiplexing_logic.sv    # Personality Logic module
../src/player_interface.sv     # Player Interface that integrates all components
../testbench/test_player_interface.sv  # Testbench for Player Interface
../testbench/multiplexing_logic_tb.sv
../testbench/command_generator_tb.sv 
../../../module02/lab02/src/hand_rank_evaluator.sv

//+define+TEST_PLAYER_INTERFACE
//-access +rwc

