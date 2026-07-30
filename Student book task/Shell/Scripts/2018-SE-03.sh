#!/bin/bash

if [[ ${#} -ne 2 ]]; then
    echo "There must be two parameters"
    exit 1
fi

if [[ ! -e ${1} ]]; then
    echo "The first parameter does not exist"
    exit 2
fi

if [[ -e ${2} ]]; then
    rm ${2}
fi

first=${1}
second=${2}
withoutId="$(cat $first | awk '{FS=","; OFS=","} {$1=""; print}' | sort | uniq)"

while read -r content; do
    matchedLines=$(cat ${first} | grep -E "${content}")
    echo "${matchedLines}" | sort -t ',' -k1 -n | head -n 1 >> $second
done< <(echo "${withoutId}")
