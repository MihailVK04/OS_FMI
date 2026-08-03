#!/bin/bash

if [[ ${#} -ne 1 ]]; then
    echo "This script needs 1 parameter"
    exit 1
fi

if [[ ! -d ${1} ]]; then
    echo "The directory does not exist"
    exit 2
fi
>foo.conf
while read -r line; do
    name=$(basename ${line})
    row=$(./validate.sh ${line})
    ec=${?}

    if [[ "${ec}" -eq 1 ]]; then
        echo "${name}:$(./validate.sh ${line})" >/dev/stderr
    elif [[ "${ec}" -eq 0 ]]; then
        cat ${line} >> foo.conf
        clearName=$(echo "${name}" | sed -E "s:.cfg$::g")
        if ! cat "foo.pwd" | grep -q -E "^${cleanName}:"; then
            password=$(pwgen 20 1)
            hashedPw=$(mkpasswd "${password}")
            echo "${cleanName}:${hashedPw}" >> "foo.pwd"
            echo "${cleanName}:${hashedPw}"
        else
            echo "User: ${cleanName} already in foo.pwd"
        fi
    else
        echo "Error running script"
    fi
done< <(find "${1}/cfg" -mindepth 1 -type f 2>/dev/null)
