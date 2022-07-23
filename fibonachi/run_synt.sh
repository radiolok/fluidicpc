#!/bin/bash

set -Eeuo pipefail


echo 'tcl run_synt.tcl fibonachi.v fibonachi'  > tcl.txt
yosys < tcl.txt

