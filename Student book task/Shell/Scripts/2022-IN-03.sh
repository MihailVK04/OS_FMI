#!/bin/bash

if [[ ${1} != "java" ]]; then
    echo "Command is not correct"
    exit 1
fi

shift 1
isJarFound=false
options=$(mktemp)
filename=""
arguments=$(mktemp)
for arg in ${@}; do
    if [[ -n ${filename} ]]; then
        echo "${arg}" >> "${arguments}"
        continue
    fi

    if [[ ${arg} =~ ^-jar$ ]]; then
        isJarFound=true
        continue
    fi

    if [[ ${isJarFound} == "false" ]] && [[ ${arg} =~ .*.jar$ ]]; then
        echo "Invalid format"
        exit 3
    fi

    if [[ ${isJarFound} == "true" ]] && [[ ${arg} =~ .*.jar$ ]]; then
        filename=${arg}
        continue
    fi

    if [[ ${arg} =~ ^- ]]; then
        if [[ ${arg} =~ ^-D.*=.*$ ]] && [[ ${isJarFound} == "false" ]]; then
            continue
        fi
        echo "${arg}" >> "${options}"
    fi

    echo "Args: ${arg}"
done
cmd=$(echo "$(cat "${options}" | tr -s '\n' ' ')-jar ${filename} $(cat "${ar
echo "java ${cmd}"
java ${cmd}

rm ${options}
rm ${arguments}
