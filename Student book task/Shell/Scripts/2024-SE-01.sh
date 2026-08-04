#!/bin/bash

if [[ ${#} -lt 2 ]]; then
    echo "The script needs no less then 2 parameters"
    exit 1
fi

if [[ ${!#} =~ ^- ]]; then
    echo "File should start with -"
    exit 2
fi

if [[ ! -f ${!#} ]]; then
    echo "File does not exist"
    exit 3
fi

filename=${!#}
replaceWord=$(mktemp)
randomKey=$(pwgen | cut -d ' ' -f1)
for arg in "${@:1:$#-1}"; do
    if [[ ! ${arg} =~ ^-R[A-Za-z0-9]+=[A-Za-z0-9]+$ ]]; then
        echo "The argument is not correct"
        exit 4
    fi
    firstWord=$(echo "${arg}" | cut -d '=' -f1 | cut -c 3-)
    secondWord=$(echo "${arg}" | cut -d '=' -f2)
    echo "${firstWord} ${secondWord}" >> ${replaceWord}
done
cat ${replaceWord}
while read -r key value; do
    sed -i -E "/^#/! s:\b${key}\b:${value}${randomKey}:g" ${filename}
done< <(cat "${replaceWord}")

sed -i -E "s:${randomKey}::g" ${filename}
