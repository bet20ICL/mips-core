#!/bin/bash

set -eou pipefail

FILENAME="$1"
INSTRUCTION="$2"

INTERNAL_FILES_1="${FILENAME}/mips_cpu/*.v"
INTERNAL_FILES_2="${FILENAME}/mips_cpu_*.v"
TESTBENCHES="test/${INSTRUCTION}_?_harvard_tb.v"
echo ${INTERNAL_FILES_1}

for i in ${TESTBENCHES}
do
    set +e
    iverilog -Wall -g2012 -o test/t  ${i} ${INTERNAL_FILES_1} ${INTERNAL_FILES_2} 2> test/dump.log
    RESULT=$?
    set -e

    if [[ RESULT -ne 0 ]] ; then
        echo "$(basename ${i} _harvard_tb.v) ${INSTRUCTION} Fail     Failed to compile"
    else
        set +e
        ./test/t > test/$(basename ${i} .v).log
        OUTPUT=$?
        set -e

        if [[ RESULT -eq 0 ]] ; then
            echo "$(basename ${i} _harvard_tb.v) ${INSTRUCITON} Pass"
        elif [[ RESULT -eq 1 ]] ; then
            echo ""
        else 
            echo ""
        fi
    fi
done