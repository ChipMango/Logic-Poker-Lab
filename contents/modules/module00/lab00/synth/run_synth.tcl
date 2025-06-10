
//------------------------------------------------------------------------------
// File Name: run_synth.tcl
// Description:-
// Author: <Student Name>
// Date: <Date>
// Version: 1.0
// Project: ChipMango Lab 00 - Digitally Representing Poker Cards
// License: ChipMango Confidential - For educational purposes only
//------------------------------------------------------------------------------
// Revision History:
//   v1.0 - 10/06/25: Initial file created with module template
//------------------------------------------------------------------------------

# run_synth.tcl: TCL script to run Cadence Genus Synthesis

# 1. Set up design libraries and directories
set WORK_DIR "./"   # Working directory for the design
set DESIGN_LIB "work"  # Library name

# 2. Define the Verilog files for synthesis (top-level module for Module 0)
read_verilog ./src/poker_player.sv

# 3. Apply constraints (optional for Module 0, no timing constraints here)
# No constraints for Module 0, but you can add timing constraints here if needed

# 4. Compile the design (this will elaborate and optimize the design)
compile_ultra -top poker_player

# 5. Run synthesis and generate reports
report_area > ./reports/area.rpt 
report_timing > ./reports/timing.rpt

# 6. Save the synthesized netlist (optional)
write_verilog -output ./reports/design_netlist.v

# 7. Log synthesis messages
log_messages -file ./reports/synthesis_log.txt

puts "Synthesis process completed"
