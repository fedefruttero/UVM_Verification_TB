if [file exists work] {vdel -all}
vlib work
vlog -f compile_sv.f
vsim -voptargs="+P4" top +UVM_TESTNAME=p4_test 
log /* -r
run -all