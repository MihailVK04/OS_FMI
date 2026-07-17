#!/bin/bash

if [[ ${#} -ne 1 ]]; then
    echo "Script needs one argument"
    exit 1
fi

file = "${1}"

if [[ ! -f "${file}" ]]; then
    echo "File ${file} does not exist"
    exit 2
fi

count = $(grep -E '[02468]' "${file}" | grep -vcE '[a-w]')

echo "Броят на търсените редове е ${count}"
