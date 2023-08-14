#!/usr/bin/env sh

# Exit immediately if any command fails
set -e

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

