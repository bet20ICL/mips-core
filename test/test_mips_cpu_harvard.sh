#!/bin/bash

set -eou pipefail

FILENAME="$1"
args=("$@")

INTERNAL_FILES_1="${FILENAME}/mips_cpu/*.v"
INTERNAL_FILES_2="${FILENAME}/mips_cpu_*.v"

if [ -z ${args[1]+x} ]
then
    TESTBENCHES="test/*_tb.v"
else
    TESTBENCHES="test/${args[1]}_*.v"
fi


for i in ${TESTBENCHES}
do
    set +e
    iverilog -Wall -g2012 -o test/t  ${i} ${INTERNAL_FILES_1} ${INTERNAL_FILES_2} 2> test/dump.log
    RESULT=$?
    set -e

    if [[ RESULT -ne 0 ]] ; then
        echo "$(basename ${i} ) $(basename ${i} _harvard_tb.v) Fail     Failed to compile"
    else
        ./test/t
    fi
done