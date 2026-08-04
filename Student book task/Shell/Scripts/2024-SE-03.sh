#!/bin/bash

if [[ ${#} -ne 1 ]]; then
    echo "The script needs 1 parameter"
    exit 1
fi

if [[ ! ${1} =~ ^[0-9]+ ]]; then
    echo "The parameter must be a positive number"
    exit 2
fi

N=$(echo "${1} % 12" | bc)
tones=$(mktemp)
text=$(mktemp)
echo "A Bb" >> ${tones}
echo "Bb B" >> ${tones}
echo "B C" >> ${tones}
echo "C Db" >> ${tones}
echo "Db D" >> ${tones}
echo "D Eb" >> ${tones}
echo "Eb E" >> ${tones}
echo "E F" >> ${tones}
echo "F Gb" >> ${tones}
echo "Gb G" >> ${tones}
echo "G Ab" >> ${tones}
echo "Ab A" >> ${tones}

while read -r line; do
    if [[ -z ${line} ]]; then
        break
    fi
    echo ${line} >> ${text}
done

akords=$(cat ${text} | grep -E -o "\[[^]]+\]" | sort | uniq)
mapToReplace=$(mktemp)
while read -r akord; do
    oneLetter=$(echo "${akord}" | cut -c 2)
    twoLetter=$(echo "${akord}" | cut -c 2-3)
    toneReplace=""
    counter=0
    accordToSave=""
    echo "${akord}" | grep -q -E "^\[[BDEGA]b"
    if [[ ${?} -eq 0 ]]; then
        toneReplace=${twoLetter}
        while true; do
            if [[ ${counter} -eq ${N} ]]; then
                break
            fi
            toneReplace=$(grep -E "^${toneReplace} " "${tones}" | cut -d ' ' -f2)
            counter=$((counter + 1))
        done
        accorfToSave="[${toneReplace}${akord:3}"
    else
        toneReplace=${oneLetter}
        while true; do
            if [[ ${counter} -eq ${N} ]]; then
                break
            fi
            toneReplace=$(grep -E "^${toneReplace} " "${tones}" | cut -d ' ' -f2)
            counter=$((counter + 1))
        done
        accordToSave="[${toneReplace}${akord:2}"
     fi
    echo "${akord} ${accordToSave}" >> ${mapToReplace}
done< <(echo "${akords}")

while read -r word toReplace; do
    cleanedWord=$(echo "${word}" | tr -d ']' | tr -d '[')
    cleanedReplace=$(echo "${toReplace}" | tr -d  ']' | tr -d '[')
    sed -i -E "s:\[${cleanedWord}\]:\[${cleanedReplace}\]:g" ${text}
done< <(cat ${mapToReplace})
cat ${text}
rm ${mapToReplace}
rm ${tones}
rm ${text}
