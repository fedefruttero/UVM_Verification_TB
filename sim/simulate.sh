#!/usr/bin/env sh
vcom ../src/P4_ADDER.vhd
vsim -c -do run.do
vdel -all
rm transcript