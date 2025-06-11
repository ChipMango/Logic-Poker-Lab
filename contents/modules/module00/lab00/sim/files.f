
//------------------------------------------------------------------------------
// File Name: files.f
// Description: Simulation setup file for running the test.
// Author: <Student Name>
// Date: <Date>
// Version: 1.0
// Project: ChipMango Lab 00 - Digitally Representing Poker Cards
// License: ChipMango Confidential - For educational purposes only
//------------------------------------------------------------------------------
// Revision History:
//   v1.0 - 10/06/25: Initial file created with module template
//------------------------------------------------------------------------------

# files.f for Module 0: Getting Started with Poker Logic Design
# Verilog/SystemVerilog files for the initial setup and basic test

src/poker_player.sv       # Top-level module for the poker player (even though it's not fully functional yet)
testbench/test_smoke_test.sv  # Basic smoke testbench for initial simulation

# Add other files that are included for the initial simulation setup

+define+SMOKE_TEST
-access +rwc  # Read, Write, and Check access for all signals
