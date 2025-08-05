#//------------------------------------------------------------------------------
#// File Name: run_synth.tcl
#// Description: The TCL script to run Cadence Genus.
#// Author: <Student Name>
#// Date: <Date>
#// Version: 1.0
#// Project: ChipMango Lab 07 - Digitally Representing Poker Cards
#// License: ChipMango Confidential - For educational purposes only
#//------------------------------------------------------------------------------
#// Revision History:
#//   v1.0 - 08/06/25: Initial file created with module template
#//------------------------------------------------------------------------------

# ----------------------------
# Setup
# ----------------------------
# Set up design libraries
#set DESIGN_LIB "work"
#set WORK_DIR "./"
set design_name poker_player

# Add Verilog files for synthesis
#read_verilog ./src/poker_player.sv
#read_verilog ./src/hand_memory.sv
#read_verilog ./src/hand_rank_evaluator.sv
#read_verilog ./src/command_generator.sv
#read_verilog ./src/personality_logic.sv
#read_verilog ./src/player_fsm.sv

# ----------------------------
# Read HDL Sources and define parameters
# ----------------------------
read_hdl -sv -define SYNTHESIS -f ../synth/design_files.f

# Enable line tracking for datapath reports (must be before elaborate)
set_db hdl_track_filename_row_col true

# ----------------------------
# Read Standard Cell Library
# ----------------------------
read_libs /CMC/kits/cadence/GPDK045/gsclib045_all_v4.4/gsclib045_lvt/timing/fast_vdd1v2_basicCells_lvt.lib

# ----------------------------
# Elaborate Design
# ----------------------------
elaborate $design_name

# Apply constraints (optional, if you have constraints.sdc)
#set_clock_constraints -period 10 -waveform {0 5} [get_clocks clk]
# ----------------------------
# Read Constraints
# ----------------------------
read_sdc ../synth/constraints.sdc

# Synthesize the design
#compile_ultra -top poker_player

# ----------------------------
# Run Checks
# ----------------------------
check_design

# ----------------------------
# Synthesis Phases
# ----------------------------
syn_gen
syn_map
syn_opt

# Report area, timing, power
report_area > ./reports/area.rpt
report_timing > ./reports/timing.rpt
report_power > ./reports/power.rpt

# Optionally write netlist
#write -format verilog -output ./reports/design_netlist.v
# ----------------------------
# Write Outputs
# ----------------------------
write_netlist > ./reports/design_netlist.v

# Save synthesis logs
redirect ./reports/synthesis_log.txt {
    report_timing
    report_area
    report_power
}

#exit
exit
