#!/bin/bash

if [[ ${#} -ne 1 ]]; then
    echo "The script needs one parameter"
    exit 1
fi

if [[ ! -d ${1} ]]; then
    echo "The parameter is not a directory"
    exit 2
fi

hashes=$(mktemp)

find ${1} -type f 2>/dev/null | xargs -I {} sha256sum {} | tr -s ' ' > ${hashes}
memory=0
groups=0
while read -r hash; do
    files=$(cat ${hashes} | grep -E "^${hash}" | cut -d ' ' -f2)
    if [[ $(echo "${files}" | wc -l) -gt 1 ]]; then
        original=$(echo "${files}" | head -n 1)
        while read -r delete; do
            echo "Deleting: ${delete}"
            fileSize=$(stat -c "%s" ${delete})
            echo "File size: ${fileSize}"
            memory=$(echo "${memory} + ${fileSize}" | bc)
            rm ${delete}
            ln -s ${original} ${delete}
        done< <(echo "${files}" | tail -n +2)
        groups=$(( ${groups} + 1 ))
    fi
done< <(cat ${hashes} | cut -d ' ' -f1 | sort | uniq)

echo "Total freed memory: ${memory}"
echo "Groups dedublicated: ${groups}"
