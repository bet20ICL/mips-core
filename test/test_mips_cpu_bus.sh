#!/bin/bash

set -eou pipefail

FILES="$1"

set +u
if [[ "$2" ]]
then
    # there is a second argument
    set -u
    INSTRUCTION="$2"
else
    # there is no second argument
    set -u
    INSTRUCTION=$( < test/instruction_names.txt )
fi

for i in ${INSTRUCTION} ; do
    test/run_one_instr_bus.sh ${FILES} ${i}
done