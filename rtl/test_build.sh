#!/bin/bash
set -eou pipefail

srcs="mips_cpu/*.v"
cpu_name="mips_cpu_harvard"

>&2 echo "Testing that submodules compile independently"
for i in ${srcs}; do
    filename=$(basename ${i} .v)
    >&2 echo "Compiling ${filename}"
    iverilog -g 2012 -s ${filename} -o mips_cpu/${filename} mips_cpu/${filename}.v 
done

>&2 echo "Testing all files compile together"
iverilog -g 2012 -s ${cpu_name} -o ${cpu_name} ${cpu_name}.v ${srcs}
RESULT=$?
if [ "${RESULT}" == "0" ]; then
    >&2 echo "All files compiled successfully"
fi