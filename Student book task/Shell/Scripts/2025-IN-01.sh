#!/bin/bash

if [[ ${#} -ne 1 ]]; then
    echo "The script expects 1 parameter"
    exit 1
fi

if [[ $(id -u) -ne 0 ]]; then
    echo "You are not root"
    exit 2
fi

objects=$(mktemp)
while read -r dir type mode; do
    if [[ ${type} == "R" ]]; then
        find "${dir}" -mindepth 1 \( -type f -o -type d \) -perm "${mode}" -
    elif [[ ${type} == "A" ]]; then
        find "${dir}" -mindepth 1 \( -type f -o -type d \) -perm "/${mode}"
    elif [[ ${type} == "T" ]]; then
        find "${dir}" -mindepth 1 \( -type f -o -type d \) -perm "-${mode}"
    fi
done< <(cat "${1}" | tr -s ' ')

while IFS= read -r -d '' file; do
    if [[ -d "${file}" ]]; then
        chmod 755 "${file}"
    else
        chmod 664 ${file}
    fi
done< <(cat "${objects}")

rm ${objects}
