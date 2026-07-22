#!/bin/bash

isNumber(){
    [[ $1 =~ ^[1-9]+[0-9]*$ ]]
}

if [[ ${#} -ne 2 ]]; then
    echo "The scripts needs two parameters"
    exit 1
fi

if ! isNumber ${1} || ! isNumber ${2} ; then
    echo "Some of the arguments is not a number"
    exit 2
fi

if [[ ${1} -eq ${2} ]]; then
    echo "The numbers should be different"
    exit 3
fi

firstNum=${1}
secondNum=${2}

if [[ ${firstNum} -gt ${secondNum} ]]; then
    tempVar=${firstNum}
    firstNum=${secondNum}
    secondNum=${tempVar}
fi

mkdir -p a
mkdir -p b
mkdir -p c

while read -r file; do
    fileRow=$(cat ${file} | wc -l)
    if [[ ${fileRow} -lt ${firstNum} ]]; then
        mv ${file} a/
    elif [[ ${fileRow} -gt "${firstNum}" && ${fileRow} -lt "${secondNum}" ]]; then
        mv ${file} b/
    else
      mv ${file} c/
    fi
done < <(find . -type f -name "*.txt")
