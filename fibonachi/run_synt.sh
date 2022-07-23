#!/bin/bash

set -Eeuo pipefail

iverilog -o fibonachi -s fibonachi_tb fibonachi.v fibonachi_tb.v -g2012
./fibonachi

echo 'tcl run_synt.tcl fibonachi.v fibonachi'  > tcl.txt
yosys < tcl.txt

