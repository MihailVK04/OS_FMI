#!/bin/bash

if [[ ! ${#} -gt 1 ]]; then
    echo "The script needs more than 1 parameter"
    exit 1
fi

if [[ ! ${1} =~ ^[1-9]+[0-9]* ]]; then
    echo "The first argument is not a number"
    exit 2
fi

sec=${1}
allSec=0
shift 1
counter=0
while [[ $(echo "${sec} > ${allSec}" | bc) -eq 1]]; do
    startTime=$(date "+%s.%N" | cut -c -13)
    $(echo "${@}") &> /dev/stdout
    endTime=$(date "+%s.%N" | cut -c -13)
    secondToTake=$(echo "scale=2;${endTime} - ${startTime}" | bc)
    allSec=$(echo "${secondToTake} + ${allSec}" | bc)
    echo "${allSec}"
    counter-$(echo "${counter} + 1" | bc)
done
echo "Runs: ${counter} ; Total time: ${allSec}"
echo "Average runtime: $(echo "scale=2;${allSec} / ${counter}" | bc) seconds
