#!/bin/bash

time=0
commandMemory=$(mktemp)
while true; do
    current=$(ps -eo pid=,comm=,rss=)
    isFoundCommand=0
    while read -r command; do
        commRun=$(echo "${current}" | grep -E ${command})
        sum=$(echo "${commRun}" | awk 'BEGIN {sum=0} {sum+=$3}\
            END {print sum}')
        if [[ ${sum} -gt 65536 ]]; then
            echo "${command} ${sum}" >> ${commandMemory}
            isFoundCommand=$(echo "${isFoundCommand} + 1" | bc)
        fi
    done< <(echo "${current}" | awk '{print $2}' | sort | uniq)
    echo "Found commands: ${isFoundCommand}"
    if [[ ${isFoundCommand} -eq 0]]; then
        break
    fi
    sleep 1
    time=$((time + 1))
done
cat ${commandMemory} | cut -d ' ' -f1 | sort | uniq -c | awk -v time=${time} '$1 > (time/2) {print $2}'
rm ${commandMemory}
