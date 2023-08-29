# Create a work library and compile VHDL sources
if [file exists work] {vdel -all}
vlib work

#compile vhdl source code of the DUT
vcom ../src/constants.vhd
vcom ../src/mux21generic.vhd
vcom ../src/fa.vhd
vcom ../src/rca.vhd
vcom ../src/csb.vhd
vcom ../src/SumGenerator.vhd
vcom ../src/pg.vhd
vcom ../src/g.vhd
vcom ../src/pg_generator.vhd
vcom ../src/CLA_SPARSE_TREE.vhd
vcom ../src/xor.vhd
vcom ../src/P4_ADDER.vhd

# Compile SystemVerilog sources
vlog -F compile_sv.f

# Optimize the design
vopt top -o top_optimized +acc +cover=sbfec+P4_ADDER(src).

# Simulate the verbose test
vsim top_optimized -coverage +UVM_TESTNAME=verbose_test
set NoQuitOnFinish 1
onbreak {resume}
log /* -r
run -all
coverage save verbose_test.ucdb

# Simulate the quiet test
vsim top_optimized -coverage +UVM_TESTNAME=quiet_test
set NoQuitOnFinish 1
onbreak {resume}
log /* -r
run -all
coverage save quiet_test.ucdb

# Merge coverage results from both tests
vcover merge P4_ADDER.ucdb quiet_test.ucdb verbose_test.ucdb

# Generate and display coverage report
vcover report P4_ADDER.ucdb -cvg -details

# Quit ModelSim
quit
