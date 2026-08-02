#!/bin/bash

if [[ ${#} -ne 3 ]]; then
    echo "The script needs 3 parameters"
    exit 1
fi

if [[ ! -f ${1} ]]; then
    echo "The first file does not exist"
    exit 2
fi

fi [[ ! -d ${3} ]]; then
    echo "The third parameter must be a directory"
    exit 3
fi

validFileNames=$(mktemp)
config=$(mktemp)
while read -r file; do
    isValid=true;
    errorInLines=$(mktemp)
    counter=0
    while read -r line; do
        counter=$((${counter} + 1))
        if [[ ${line} =~ ^ ]] || [[ ${line} =~ ^\{[^\}]*\;$ ]] || [[ ${line} == "" ]]; then
            continue
        fi
        echo "Line ${counter}:${line}" >> "${errorInLines}"
        isValid=false
    done< <(cat "${file}")
    if [[ ${isValid} == "true" ]]; then
        echo "${file}" >> "${validFileNames}"
    else
        echo "Error in $(basename ${file})"
        while read -r error; do
            echo "${error}"
        done< ${errorInLines}
    fi
    rm ${errorInLines}
done< <(find ${3} -mindepth 1 -type f -name "*.cfg" 2>/dev/null)

while read -r valid; do
    cat "${valid}" >> "${config}"
    name=$(basename ${valid} | sed -E "s:(.*).cfg$:\1:g")
    if ! grep -q -E "^${name}:" ${1}; then
        pw=$(pwgen 20 1)
        echo "${name}:${pw}" >> ${1}
        echo "${name}:${pw}"
    fi
done < ${validFileNames}

cat "${config}" > ${2}

rm ${config}
rm ${validFileNames}
