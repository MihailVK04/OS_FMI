#!/bin/bash

if [[ $(id -u) -ne 1 ]]; then
    echo "You are not root"
    exit 2
fi

filename=${1}
result=$(cat ${filename} | grep -E -v "home/")

while read -r row; do
    path=$(echo "${row}" | cut -d ":" -f6)

    if [[ -w ${path} ]]; then
    echo "${row}" >> result
    fi
done < <(cat ${filename} | grep -E "home/")

echo "${result}"
