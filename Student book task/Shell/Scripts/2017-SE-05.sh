#!/bin/bash

if [[ ${#} -ne 2 ]]; then
    echo "This script needs two parameters"
    exit 1
fi

if [[ ! -d ${1} ]]; then
    echo "The first parameter must be a directory"
    exit 2
fi

regRes=$(mktemp)
while read -r line; do
    name=$(basename ${line})
    if [[ ${name} =~ ^vmlinuz-[0-9]+\.[0-9]+\.[0-9]+-${2} ]]; then
        echo "${name}" >> ${regRes}
    fi
done< <(find ${1} -maxdepth 1 -type f)

cat ${regRes} | sort -t '.' -k1 -k2 -k3 -nr | head -n 1
rm ${regRes}
