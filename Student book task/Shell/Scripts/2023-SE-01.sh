#!/bin/bash

if [[ ${#} -ne 2 ]]; then
    echo "The script needs 2 parameters"
    exit 1
fi

if [[ ! -f ${1} ]]; then
    echo "The first file does not exist"
    exit 2
fi

if [[ ! ${1} =~ .*.csv]]; then
    echo "The first file must be csv"
    exit 3
fi

type=$(cat "${1}" | grep -E "^[^,]*,[^,]*,[^,]*,[^,]*,${2}.*$")
starsign=$(echo "${type}" | cut -d ',' -f4 | sort | uniq -c | sort -nr | hea
starsignMost=$(echo "${type}" | grep -E "^[^,]*,[^,]*,[^,]*,${starsign}.*$")

mostBright=$(echo "${starsignMost}" | sort -t ',' -k7n | head -n 1)

echo "${mostBright}" | cut -d "," -f1
