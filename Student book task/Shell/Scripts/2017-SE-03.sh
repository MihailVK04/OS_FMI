#!/bin/bash

if [[ $(id -u) -ne 0 ]]; then
    echo "You are not root"
    exit 1
fi

userProccesInfo=$(mktemp)
ps -eo user=,rss=,pss= | awk '\
{rss[$1]+=$2} {counter[$1]+=1}
END {for(user in rss) {
    print user " " counter[user] " " rss[user]
}}' > ${userProccesInfo}
cat ${userProccesInfo}

while read -r user count totalRss; do
    maxMemoryProcces=$(ps -u ${user} -o rss=,pid= 2>/dev/null | sort -nr | head -n 1)
    doubleMemory=$(echo "${totalRss}/${count} * 2" | bc)
    echo "Highest memory for ${user}: ${maxMemoryProcces}"
    echo "Double to check: ${doubleMemory}"
    rssHighest=$(echo "${maxMemoryProcces}" | awk '{print $1}')
    echo "Top 1: ${rssHighest}"
    pidHighest=$(echo "${maxMemoryProcces}" | awk '{print $2}')
    echo "Top 1 pid: ${pidHighest}"
    if [[ ${rssHighest} -ge ${doubleMemory} ]]; then
        echo "End ${user} procces: ${pidHighest}"
        kill ${pidHighest}
    fi
done< <(cat ${userProccesInfo})
rm "${userProccesInfo}"
