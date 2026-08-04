#!/bin/bash

if [[ ${#} -ne 2 ]]; then
    echo "The script needs 2 parameters"
    exit 1
fi

if [[ ! -d ${1} ]]; then
    echo "First parameter must be a dir"
    exit 2
fi

createDir=${2}
if [[ ! -d ${2} ]]; then
    mkdir ${createDir}
fi

filesInDir=$(mktemp)
start=""
end=""
copyFiles() {
    dirToCreate="${createDir}/${start}_${end}"
    mkdir -p "${dirToCreate}" 2>/dev/null
    while read -r line; do
        fileToCopy=$(echo "${line}" | cut -d ' ' -f1)
        newName=$(echo "${line}" | cut -d ' ' -f2)
        cp "${fileToCopy}" "${dirToCreate}/${newName}.jpg" 2>/dev/null
    done< <(cat ${filesInDir})
}

while read -r line; do
    file=$(echo "${line}" | cut -d ' ' -f1)
    date=$(echo "${line}" | cut -d ' ' -f2 | cut -d '+' -f1)
    hours=$(echo "${line}" | cut -d ' ' -f2 | cut -d '+' -f2 | cut -d '.' -f2)
    if [[ -z ${start} ]]; then
        start=${date}
        end=${date}
    fi

    if [[ ${end} == ${date} || $(date -d "${end} + 1 day" +'%Y-%m-%d') == ${date} ]]; then
        echo "${file} ${date}_${hours}" >> ${filesInDir}
        end=${date}
    else
        copyFiles
        start=${date}
        end=${date}
        echo "${file} ${date}_${hours}" > ${filesInDir}
    fi
done< <(find ${1} -type f -name "*.jpg" -printF "%p %T+\n" 2>/dev/null | sort -k2)

copyFiles
rm ${filesInDir}
