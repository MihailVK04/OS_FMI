#!/bin/bash

if [[ ${#} -ne 3 ]]; then
    echo "The script needs 3 parameters"
    exit 1
fi

if [[ ! -f ${1} ]]; then
    echo "The first file does not exist"
    exit 2
fi

if [[ ! -f ${2} ]]; then
    echo "The second file does not exist"
    exit 3
fi

first=$(cat "${1}" | grep -E "^${3}")
second=$(cat "${2}" | grep -E "^${3}")

if [[ -z ${first} ]] && [[ -z ${second} ]]; then
    echo "There is no black hole"
    exit 4
fi

if [[ -z ${first} ]]; then
    echo "${2}"
    exit 0
fi

if [[ -z ${second} ]]; then
    echo "${1}"
    exit 0
fi

distance1=$(echo "${first}" | cut -d ':' -f2 | awk '{print $1}')
distance2=$(echo "${second}" | cut -d ':' -f2 | awk '{print $1}')

if [[ ${distance1} -lt ${distance2} ]]; then
    echo "S{1}"
    elif [[ ${distance2} -lt ${distance1} ]]; then
        echo "${2}"
    else
        echo "${1} ${2}"
fi
