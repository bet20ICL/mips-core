#!/bin/bash
set -eou pipefail

iverilog -g 2012 -s alu_tb -o alu_tb alu_tb.v alu.v

./alu_tb

