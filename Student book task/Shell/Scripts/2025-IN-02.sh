#!/bin/bash

if [[ ${#} -ne 2 ]]; then
    echo "The script needs 2 parameters"
    exit 1
fi

if [[ ! -f ${2} ]]; then
    echo "The second parameter is not a file"
    exit 2
fi

while read -r artist; do
    info=$(cat "${2}" | grep -E " ${artist}$")
    echo "; team ${artist}"
    while read -r composer; do
        while read -r hostname; do
            echo "${composer} IN NS ${hostname}.${1}."
        done< <(echo "${info}" | cut -d ' ' -f1)
    done< <(echo "${info}" | cut -d ' ' -f2)
done< <(cat "${2}" | tr -s ' ' | cut -d ' ' -f3 | sort | uniq)
