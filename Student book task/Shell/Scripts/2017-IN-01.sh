#!/bin/bash

if [[ ${#} -ne 3 ]]; then
    echo "The script needs 3 parameters"
    exit 1
fi

if [[! -f ${1} ]]; then
    echo "The first parameters is not a file"
    exit 2
fi

secondKey=$(grep -E "^${3}=" ${1})
if [[ ${?} -ne 0 ]]; then
    cat "${1}"
    exit 3
fi
firstKeyArgs=$(cat ${1} | grep -E "^${2}=" | cut -d '=' -f2- | grep -o .)
secondKeyArgs=$(echo "${secondKey}" | cut -d '=' -f2- | grep -o .)

result=$(comm -1 -3 <(echo "${firstKeyArgs}" | sort) <(echo "${secondKeyArgs}" | sort) | tr '\n' ' ')
sed -E -i "s:(^${3}).*:\1=${result}:g" ${1}
