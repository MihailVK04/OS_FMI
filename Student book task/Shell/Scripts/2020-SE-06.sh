#!/bin/bash

if [[ ${#} -ne 3 ]]; then
    echo "This script needs 3 parameters"
    exit 1
fi

if [[ ! -f ${1} ]]; then
    echo "The first parameter is not a file"
    exit 2
fi

updateFile=$(mktemp)
user=$(whoami)
date=$(date)
cat "${1}" | tr -s " " | cut -d '#' -f1 | sed "/^$/d" >> "${updateFile}"
if grep -q -E "^${2}\b" "${updateFile}"; then
    sed -E -i "s/^(${2}\b.*)$/\#\1 \# edited at ${date} by ${user}/g" "${1}"
    sed -i -E "/^\#${2}/a ${2} = ${3} \# added at ${date} by ${user}" "${1}"
else
    echo "${2} = ${3} \# added at ${date} by ${user}" >> "${1}"
fi

rm ${updateFile}
