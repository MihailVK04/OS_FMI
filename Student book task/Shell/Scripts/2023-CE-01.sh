#!/bin/bash

if [[ ${#} -ne 2 ]]; then
    echo "The script needs 2 parameters"
    exit 1
fi

if [[ ! -f ${1} ]]; then
    echo "The first file does not exist"
    exit 2
fi

if [[ ! -d ${2} ]]; then
    echo "The directory does not exist"
    exit 3
fi

isWord() {
    [[ $1 =~ [a-zA-Z0-9_] ]]
}

while read -r file; do
    while read -r word; do
        echo "Word: ${word}"
        censorer=$(echo ${word} | sed -E 's:.:\*:g')
        caseWord=$(cat "${file}" | grep -E -o -i " ${word} " | tr -d ' ')
        while read -r change; do
            sed -i -E "s: ${change} : ${censorer} :g" "${file}"
        done< <(echo "${caseWord}")
    done< <(cat ${1})
done< <(find ${2} -type f -name "*.txt" 2>/dev/null)
