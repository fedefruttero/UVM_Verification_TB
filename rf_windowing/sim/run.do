if [file exists work] {vdel -all}
vlib work

vcom ../src/constants.vhd;
vcom ../src/registerfileWindowing.vhd;

vlog -F compile_sv.f 

vsim -voptargs="+acc" top +UVM_TESTNAME=verbose_test +UVM_NO_RELNOTES;
run -all