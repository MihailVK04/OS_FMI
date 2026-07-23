#!/bin/bash

if [[ ${#} -ne 3 ]]; then
    echo "There must be 3 parameters for this script"
    exit 1
fi

fi [[ ! -d ${1} || ! -d ${2} || $(find ${2} -type f | wc -l) -gt 0 ]]; then
    echo "The first and second parameters are no directories or the second isnt empty"
    exit 2
fi

if [[ $(id -u) -ne 0 ]]; then
    echo "You are not root"
    exit 3
fi

while read -r path; do
    base=$(basename ${path})
    dir=$(dirname ${path})
    echo "Basename: ${base}"
    echo "Dirname: ${dir}"
    editedDir=$(echo ${dir} | sed -E s:${1}:${2}:g)
    mkdir -p ${editedDir}
    cp ${path} "${editedDir}/"
done< <(find ${1} -type f -name "*${3}*")
