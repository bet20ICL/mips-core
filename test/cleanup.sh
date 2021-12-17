#!/bin/bash
set -eou pipefail

srcs="test/tb_outputs/*"

set +e
for i in ${srcs}; do
    
    >&2 echo "Removing ${i}"
    rm ${i}

done
set -e