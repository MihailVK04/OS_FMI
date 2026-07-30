#!/bin/bash

if [[ ${#} -ne 2 ]]; then
    echo "This script needs two parameters"
    exit 1
fi

if [[ ! -e ${1} ]]; then
    echo "First parameter does not exist"
    exit 2
fi

if [[ ! -d ${2} ]]; then
    echo "Second parameter is not a directory"
    exit 3
fi

if [[ $(find ${2} -type f | wc -l) -ne 0 ]]; then
    echo "The directory is not empty"
    exit 4
fi

touch ${2}/dict.txt
counter=1
while read -r name; do
    echo "${name};${counter}" >> ${2}/dict.txt
    touch ${2}/${counter}.txt
    cat ${1} | grep -E "${name}" >> ${2}/${counter}.txt
    counter= $(echo "$counter + 1" | bc)
done< <(cat ${1} | cut -d ":" -f1 | sed s:" \(.*\)$"::g | sort | uniq)
