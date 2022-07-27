#!/bin/bash

set -Eeuo pipefail

WIDTH=4
if [ -f *.vcd ]; then
  rm *.vcd
fi

iverilog -o adder -P adder_tb.WIDTH=${WIDTH} -s adder_tb adder_tb.v adder.v -g2012
./adder
echo 'tcl run_synt.tcl adder.v adder '${WIDTH}  > tcl.txt
yosys < tcl.txt

