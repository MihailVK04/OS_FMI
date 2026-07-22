#!/bin/bash

if [[ ${#} -ne 2 ]]; then
    echo "The script accepts two parameters"
    exit 1
fi

if ! [[ -e ${1} && -e ${2} ]]; then
    echo "File or both dont exist"
    exit 2
fi

if [[ -e "${1}.songs" || -e "${2}.songs" ]]; then
    echo "The script has been already ran with one of the parameters and the
    exit 3
fi

winner(){
    file=${1}
    fileContent=$(cat ${1} | tr -s ' ' | cut -d ' ' -f4-)
    echo "${fileContent}" | sort > "${1}.songs"
}

firstFileLines=$(grep -E "${1}" ${1} | wc -l)
secondFileLines=$(grep -E "${2}" ${2} | wc -l)

if [[ ${firstFileLines} -gt ${secondFileLines} ]]; then
    winner ${1}
else
    winner ${2}
fi
