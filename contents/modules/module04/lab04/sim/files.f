//------------------------------------------------------------------------------
// File Name: files.f
// Description:  Simulation setup file for running the test.
// Author: <Student Name>
// Date: <Date>
// Version: 1.0
// Project: ChipMango Lab 04 - Digitally Representing Poker Cards
// License: ChipMango Confidential - For educational purposes only
//------------------------------------------------------------------------------
// Revision History:
//   v1.0 - 07/06/25: Initial file created with module template
//------------------------------------------------------------------------------

# files.f for Module 4: Control FSM and Game Flow

../src/player_fsm_controller.sv           # FSM for controlling game flow
../src/game_fsm_controller.sv
../testbench/test_game_fsm.sv   # Testbench for FSM and Game Flow
../testbench/timeout_counter_tb.sv

//+define+TEST_GAME_FSM
//+define+TIMEOUT_COUNTER_TB
//-access +rwc



