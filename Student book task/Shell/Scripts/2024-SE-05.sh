#!/bin/bash

if [[ ${#} -ne 2 ]]; then
    echo "The script needs 2 parameters"
    exit 1
fi
currentTime=$(date +"%A %F %H")
weekDay=$(date +"%A")
hour=$(date +"%H")
value=$(${1})
if [[ ${?} -ne 0 ]]; then
    exit 2
fi

result=$(cat ${2} | grep -E "^${weekDay}" | \
awk -v hour=${hour} -F ' ' '$3 ~ /^hour/ {print $0}')

status=$(echo "${result}" | awk -v value=${value} -F ' ' '{sum+=$4}
END
{
    avg=sum/NR;
    if(value > 2*avg || value < avg/2) {
        print "Error is not correct"
    }
}
')
if [[ -n ${status} ]]; then
    echo "$(date +"%F %H"): ${value} abnormal"
    exit 3
fi

echo "${currentTime} ${value}" >> ${2}
