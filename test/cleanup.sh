#!/bin/bash
set -eou pipefail

srcs="test/tb_outputs/*.log"

set +e
for i in ${srcs}; do
    
    >&2 echo "Removing ${i}"
    rm ${i}

done
set -e

srcs="test/tb_outputs/*_tb"

set +e
for i in ${srcs}; do
    
    >&2 echo "Removing ${i}"
    rm ${i}

done
set -e