#!/bin/bash

if [[ ${#} -lt 1 || ${#} -gt 2 ]]; then
    echo "Not correct count of parameters"
    exit 1
fi

if [[ ! -d ${1} ]]; then
    echo "Not a directory"
    exit 2
fi

counter=0
while read -r line; do
    base=$(basename ${line})
    pathToLink=$(readlink ${line})
    if [[ ! -e ${pathToLink} ]]; then
        counter=$(echo "${counter} + 1" | bc)
        continue
    fi

    if [[ -z ${2} ]]; then
        echo "${base} -> ${pathToLink}"
    else
        echo "${base} -> ${pathToLink}" >> ${2}
    fi
done< <(find ${1} -type l)

if [[ -z ${2} ]]; then
    echo "Broken symlinks: ${counter}"
else
    echo "Broken symlinks: ${counter}" >> ${2}
fi
