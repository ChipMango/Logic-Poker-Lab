//------------------------------------------------------------------------------
// File Name: run_synth.tcl
// Description: The TCL script to run Cadence Genus.
// Author: <Student Name>
// Date: <Date>
// Version: 1.0
// Project: ChipMango Lab 07 - Digitally Representing Poker Cards
// License: ChipMango Confidential - For educational purposes only
//------------------------------------------------------------------------------
// Revision History:
//   v1.0 - 08/06/25: Initial file created with module template
//------------------------------------------------------------------------------

# Set up design libraries
set DESIGN_LIB "work"
set WORK_DIR "./"

# Add Verilog files for synthesis
read_verilog ./src/poker_player.sv
read_verilog ./src/hand_memory.sv
read_verilog ./src/hand_rank_evaluator.sv
read_verilog ./src/command_generator.sv
read_verilog ./src/personality_logic.sv
read_verilog ./src/player_fsm.sv

# Apply constraints (optional, if you have constraints.sdc)
set_clock_constraints -period 10 -waveform {0 5} [get_clocks clk]

# Synthesize the design
compile_ultra -top poker_player

# Report area, timing, power
report_area > ./reports/area.rpt
report_timing > ./reports/timing.rpt
report_power > ./reports/power.rpt

# Optionally write netlist
write -format verilog -output ./reports/design_netlist.v

# Save synthesis logs
log_messages -file ./reports/synthesis_log.txt
