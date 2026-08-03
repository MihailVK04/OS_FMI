#!/bin/bash

if [[ ${#} -ne 1 ]]; then
    echo "This script needs 1 parameter"
    exit 1
fi

if [[ ! -f ${1} ]]; then
    echo "The parameter must be a file"
    exit 2
fi
procFile="wakeupExample"
cleanedFile=$(mktemp)
while read -r line; do
    if [[ -z ${line} ]]; then
        continue
    fi
    clearLine=$(echo "${line}" | tr -s ' ')
    device=$(echo "${line}" | awk '{print $1}')
    if [[ ${device} -gt 4 || ! ${device} =~ ^[A-Z0-9]*$ ]]; then
        echo "Device does not meet the criteria: ${device}"
        continue
    fi
    status=$(echo "${line}" | awk '{print $2}')
    if [[ ! ${status} =~ ^(enabled|disabled)$ ]]; then
        echo "Status must be enabled or disabled: ${status}"
        continue
    fi
    echo "${device} ${status}" >> ${cleanedFile}
done< <(cat ${1} | sed -E "s:^([^#]*)#.*$:\1:g")

while read -r line; do
    currDevice=$(echo "${line}" | cut -d ' ' -f1)
    currStatus=$(echo "${line}" | cut -d ' ' -f2)
    if ! grep -E -q "${currDevice}" ${procFile}; then
        echo "There is no device with such name: ${currDevice}"
        continue
    fi
    lineToChange=$(cat ${procFile} | grep -E "${currDevice}")
    lineStatus=$(echo "${lineToChange}" | awk '{print $3}' | tr -d '*')
    if [[ "${lineStatus}" != "${currStatus}" ]]; then
        sed -E -i "s:^(.*${currDevice}.*)\*${lineStatus}(.*)$:\1\*${currStatus}\2:" "${procFile}"
    fi
done< <(cat ${cleanedFile})

rm ${cleanedFile}
