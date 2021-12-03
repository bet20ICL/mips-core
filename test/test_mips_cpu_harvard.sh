#!/bin/bash

set -eou pipefail

FILES="$1"

set +u
if [[ "$2" ]]
then
    set -u
    # there is a second argument
    INSTRUCTION="$2"
else
    set -u
    INSTRUCTION=$( < test/instruction_names.txt )
    echo ${INSTRUCTION} | tr '[:upper:]' '[:lower:]'
fi

for i in ${INSTRUCTION} ; do
    test/run_one_instr.sh ${FILES} ${i} | tr '[:upper:]' '[:lower:]'
done