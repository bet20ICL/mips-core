#!/bin/bash

set -eou pipefail

args=("$@")

INTERNAL_FILES_1="${args[0]}/mips_cpu/*.v"
INTERNAL_FILES_2="${args[0]}/mips_cpu_*.v"

if [ -z ${args[1]+x} ]
then 
    TESTBENCHES="test/*_tb.v"
else
    TESTBENCHES="test/${args[1]}_*.v"
fi


for i in ${TESTBENCHES}
do
    iverilog -Wall -g2012 -o test/t  ${i} ${INTERNAL_FILES_1} ${INTERNAL_FILES_2}
done