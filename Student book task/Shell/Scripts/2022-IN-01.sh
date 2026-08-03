#!/bin/bash

if [[ ${#} -ne 2 ]]; then
    echo "The script needs 2 parameters"
    exit 1
fi

if [[ ! -d ${1} ]]; then
    echo "The first parameter is not a directory"
    exit 2
fi

if [[ ! -d ${2} ]]; then
    echo "The second parameter is not a directory"
    exit 3
fi

if [[ -n $(find ${2} -mindepth 1) ]]; then
    echo "The second directory should be empty"
    exit 4
fi

cleanFiles=$(mktemp)
while read -r line; do
    dirName=$(dirname ${line} | sed -E "s:^[^/]*:${2}:g")
    mkdir -p ${dirName}
    echo "${line}" >> "${cleanFiles}"
done< <(find ${1} -mindepth 1 -type f ! name "*.swp" 2>/dev/null)

while read -r line; do
    name=$(basename ${line} | cut -d '.' -f2)
    directory=$(dirname ${line})
    if ! grep -E -q "^${directory}/${name}$" "${cleanFiles}"; then
        echo "${line}" >> ${cleanFiles}
    fi
done< <(find ${1} -mindepth 1 -name "*.swp" 2>/dev/null)
cat "${cleanFiles}"

while read -r path; do
    dirPath=$(echo "${path}" | cut -d '/' -f2-)
    cp "${path}" "${2}/${dirPath}"
done< ${cleanFiles}

rm ${cleanFiles}
