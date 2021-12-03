#!/bin/bash

set -eou pipefail

FILENAME="$1"
INSTRUCTION="$2"

INTERNAL_FILES_1="${FILENAME}/mips_cpu/*.v"
INTERNAL_FILES_2="${FILENAME}/mips_cpu_*.v"
TESTBENCHES="test/tb/${INSTRUCTION}*_harvard_tb.v"


for i in ${TESTBENCHES}
do
    set +e
    iverilog -Wall -g2012 -o test/tb_outputs/$(basename ${i} .v)  ${i} ${INTERNAL_FILES_1} ${INTERNAL_FILES_2} 2> test/tb_outputs/$(basename ${i} .v)_dump.log
    RESULT=$?
    set -e

    if [[ RESULT -ne 0 ]] ; then
        echo "$(basename ${i} _harvard_tb.v) ${INSTRUCTION} Fail     Failed to compile"
    else
        echo "$(basename ${i} _harvard_tb.v) ${INSTRUCTION} Compiled"
        set +e
        ./test/tb_outputs/$(basename ${i} .v) > test/tb_outputs/$(basename ${i} .v).log
        OUTPUT=$?
        set -e

        if [[ OUTPUT -eq 0 ]] ; then
            echo "$(basename ${i} _harvard_tb.v) ${INSTRUCTION} Pass"
        elif [[ OUTPUT -eq 1 ]] ; then
            echo "$(basename ${i} _harvard_tb.v) ${INSTRUCTION} Fail"
        else
            echo "$(basename ${i} _harvard_tb.v) ${INSTRUCTION} Fail"
        fi
    fi
done