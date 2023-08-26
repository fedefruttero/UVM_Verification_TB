#!/usr/bin/env sh

# Exit immediately if any command fails
set -e


vcom constants.vhd
vcom registerfileWindowing.vhd
vcom tb_registerfileWindowing.vhd

vsim -do dofileREG.do
