#!/bin/bash

if [[ ${#} -ne 1 ]]; then
    echo "The script needs 1 parameter"
    exit 1
fi

if [[ ! -d ${1} ]]; then
    echo "The parameter is not a directory"
    exit 2
fi

filesToDelete=$(mktemp)
shaSums=$(find ${1} -type f -printf "%n " -exec sha256sum {} ';')
while read -r uniqHash; do
    group=$(echo "${shaSums}" | grep -E "${uniqHash}" | tr -s ' ' | sort -n)
    if [[ $(echo "${group}" | wc -l ) -eq 1 ]]; then
        continue
    fi
    linkCount=$(echo "${group}" | cut -d ' ' -f1 | head -n 1)
    if [[ $(echo "${group}" | grep -E "^${linkCount}" | wc -l) -eq $(echo "${group}" | wc -l) ]]; then
        if [[ $(echo ${linkCount}) -eq 1 ]]; then
            while read -r link hash filename; do
                echo "${filename}" >> ${filesToDelete}
            done< <(echo "${group}" | tail -n +2)
        else
            echo "${group}" | cut -d ' ' -f3 | head -n 1 >> ${filesToDelete}
        fi
    else
        while read -r link hash filename; do
            echo "${filename}" >> ${filesToDelete}
        done< <(echo "${group}" | grep -E "^1")
        echo "${group}" | grep -E -v "^1" | cut -d ' ' -f3 | head -n 1 >> ${filesToDelete}
    fi
done< <(echo "${shaSums}" | tr -s ' ' | cut -d ' ' -f2 | sort | uniq)

cat ${filesToDelete}
rm ${filesToDelete}
