#!/usr/bin/env sh

# Exit immediately if any command fails
set -e


./compilep4.sh
vlib work
vlog -F compile_sv.f
vsim -c -do run.do top
vdel --all

