#!/bin/bash
set -eou pipefail

rm mips_cpu_harvard

srcs="mips_cpu/*.v"

>&2 echo "Testing that submodules compile independently"
set +e
for i in ${srcs}; do
    filename=$(basename ${i} .v)
    
    >&2 echo "Removing ${filename}"
    rm mips_cpu/${filename}

done
set -e