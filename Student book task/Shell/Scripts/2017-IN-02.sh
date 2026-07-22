#!/bin/bash

if [[ ${#} -ne 1 ]]; then
    echo "The script needs one parameter"
    exit 1
fi

if [[ $(id -u) -ne 1 ]]; then
    echo "The user is not root"
    exit 2
fi

currUserProcesses=$(ps -u ${1} -o pid= | wc -l)
ps -eo user= | sort | uniq -c | sort -rn | awk -v max=${currUserProcesses} '
avgTime=$(ps -eo user=,pid=,cputimes= | awk 'BEGIN {allSeconds=0} {allSecond
echo "${avgTime}"
limit=$(echo "scale=2; ${avgTime} * 2" | bc)
echo "${limit}"
while read -r pid time; do
    echo "PID : ${pid}"
    echo "TIME : ${time}"
    if [[ $(echo "${time} > ${limit}" | bc) eq 1 ]]; then
        kill ${pid}
    fi
done< <(ps -u ${1} -o pid=,cputimes=)
