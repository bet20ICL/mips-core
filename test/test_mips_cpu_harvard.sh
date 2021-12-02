#!/bin/bash

set -eou pipefail

FILES="$1"
ARGS="$@"

if [ -z ${args[1]+x} ]
then
    echo "empty"
    INSTRUCTION=""
else
    INSTRUCITON
fi