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
set design_name poker_player

# 2. Define the Verilog files for synthesis (top-level module for Module 0)
read_hdl -sv ../src/poker_player.sv

# 3. Enable line tracking for datapath reports (must be before elaborate)
set_db hdl_track_filename_row_col true

# ----------------------------
# 4. Read Standard Cell Library
# ----------------------------
read_libs /CMC/kits/cadence/GPDK045/gsclib045_all_v4.4/gsclib045_lvt/timing/fast_vdd1v2_basicCells_lvt.lib

# ----------------------------
# 5. Elaborate Design
# ----------------------------
elaborate $design_name


# 6. Apply constraints (optional for Module 0, no timing constraints here)
# No constraints for Module 0, but you can add timing constraints here if needed
# ----------------------------
# 6. Read Constraints -- optional
# ----------------------------
read_sdc ../synth/constraints.sdc

# ----------------------------
# 7. Run Checks
# ----------------------------
check_design

# ----------------------------
# 8. Synthesis Phases
# ----------------------------
syn_gen
syn_map
syn_opt

# 6. Save the synthesized netlist (optional)

# ----------------------------
# Write Outputs
# ----------------------------
write_hdl > reports/design_netlist.sv

# 5. Run synthesis and generate reports
# ----------------------------
# Reports
# ----------------------------
report_area  > reports/area.rpt
report_timing > reports/timing.rpt
report_power > reports/power.rpt

# ----------------------------
# Exit
# ----------------------------
exit

