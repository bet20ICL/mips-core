#!/bin/bash

set -eou pipefail

args=("$@")

INTERNAL_FILES="${args[0]}/*/*.v"
CPU_FILES="${args[0]}/*_harvard_*.v"

for i in ${INTERNAL_FILES}; do
    echo ${i}
done

for i in ${CPU_FILES}; do 
    echo ${i}
done