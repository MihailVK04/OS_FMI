#!/bin/bash

if [[ ${#} -ne 1 ]]; then
    echo "The scripts need 1 parameter"
    exit 1
fi

if [[ ! -d ${1} ]]; then
    echo "The parameter is not a directory"
    exit 2
fi
wordCountFile=$(mktemp)
allWordCount=$(mktemp)
stopWordsFinal=$(mktemp)
fileCount=$(find ${1} -type f | wc -l)
while read -r file; do
    words=$(cat "${file}" | grep -E -o "[a-z]+")
    echo "${words}" >> ${allWordCount}
    echo "${words}" | sort | uniq -c | awk '$1 >= 3 {print $2}' >> ${wordCountFile}
done< <(find ${1} -type f -name "*.txt")
cat ${wordCountFile} | sort | uniq -c | sort -nr | awk -v minFile=${fileCount} '$1 >minFile/2 {print $2}' | head -n 10 >>${stopWordsFinal}
result=$(mktemp)
while read -r word; do
    cat ${allWordCount} | sort | uniq -c | sort -nr | grep -E "\b${word}\b" | tr -s ' ' | sed -E "s:^ ::g" >> ${result}
done< <(cat ${stopWordsFinal})
cat ${result} | sort -nr

rm ${result}
rm ${stopWordsFinal}
rm ${wordCountFile}
rm ${allWordCount}
