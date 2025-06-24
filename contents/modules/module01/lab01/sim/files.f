//------------------------------------------------------------------------------
// File Name: files.f
// Description:  Simulation setup file for running the test.
// Author: <Student Name>
// Date: <Date>
// Version: 1.0
// Project: ChipMango Lab 01 - Digitally Representing Poker Cards
// License: ChipMango Confidential - For educational purposes only
//------------------------------------------------------------------------------
// Revision History:
//   v1.0 - 06/06/25: Initial file created with module template
//------------------------------------------------------------------------------

# files.f for Module 1: Hand Memory
../src/hand_memory.sv          # Source file for Hand Memory
../src/bubble_sort.sv
../testbench/test_hand_memory.sv  # Testbench for Hand Memory
../testbench/bubble_sort_tb.sv

//+define+TEST_HAND_MEMORY
//+define+BUBBLE_SORT_TB
//-access +rwc  # Read, Write, and Check access for all signals
