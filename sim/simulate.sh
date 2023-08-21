#!/usr/bin/env sh

# Exit immediately if any command fails
set -e

vsim -do run.do top &

