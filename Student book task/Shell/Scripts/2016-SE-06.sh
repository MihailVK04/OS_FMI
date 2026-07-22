#!/bin/bash

if [[ ${#} -ne 1 ]]; then
    echo "The script accepts one argument"
    exit 1
fi

if [[ ! -f ${1} ]]; then
    echo "This is not a file"
    exit 2
fi

counter=1
result=$(mktemp)
while read -r line; do
    removedYear=$(echo "${line}" | cut -d '-' -f2-)
    echo "${counter}.${removedYear}" >> ${result}
    counter=$(echo "${counter}+1" | bc)
done< <(cat ${1})

cat "${result}" | sort -k2 -t '"'
rm "${result}"
