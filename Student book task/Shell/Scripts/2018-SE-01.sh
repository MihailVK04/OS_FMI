#!/bin/bash

if [[ ${#} -ne 1]]; then
    echo "There must be one parameter"
    exit 1
fi

if [[ ! -d ${1} ]]; then
    echo "The parameter must be a directory"
    exit 2
fi

friendMessagesRows=$(mktemp)

while read -r file; do
    rowCount=$(cat ${file} | wc -l)
    dirName=$(dirname ${file})
    friend=$(echo ${dirName} | awk -F / '{print $NF}')
    echo "${friend} ${rowCount}" >> ${friendMessagesRows}
done< <(find ${1} -type f -name "*.txt")
totalMessagesWithFriend=$(mktemp)
cat "${friendMessagesRows}" | awk 'BEGIN {friend[$1]=0} {friend[$1]+=$2} \
END \
{
    for(fr in friend) {
        print fr " " friend[fr]
    }
}
' >> ${totalMessagesWithFriend}
cat ${totalMessagesWithFriend} | sort -t ' ' -k2 -nr | head -n 10

rm ${friendMessagesRows}
rm ${totalMessagesWithFriend}
