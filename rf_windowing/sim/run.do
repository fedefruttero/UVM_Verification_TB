# ----------------------------------------------------------------------------
# Title: Compile and Run Script for RF Testbench
# Author: Federico Fruttero
# Description: This script compiles and runs the RF testbench. It generates
#              coverage reports and saves them in UCDB format.
# ----------------------------------------------------------------------------

# Compile VHDL source files
vcom ../src/constants.vhd;
vcom ../src/registerfileWindowing.vhd;

# Compile SystemVerilog source files
vlog -F compile_sv.f

# Optimize the design
vopt top -o top_optimized +acc +cover=sbfec+registerfileWindowing(src)

# Simulate the optimized design
vsim -sv_seed random top_optimized -coverage +UVM_TESTNAME=verbose_test +UVM_NO_RELNOTES;

# Set simulation settings
set NoQuitOnFinish 1
onbreak {resume}
log /* -r

# Run the simulation
run -all

# Save coverage data in UCDB format
coverage save verbose_test.ucdb

# Generate coverage report
vcover report verbose_test.ucdb -cvg -details

# Exit the simulation
quit
