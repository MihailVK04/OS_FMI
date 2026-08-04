#!/bin/bash

if [[ ${#} -ne 1 ]]; then
    echo "The script needs 1 parameter"
    exit 1
fi
currDepend=${1}
bakefile="bakefile"
if ! grep -E -q "^${1}" "${bakerfile}"; then
    if [[ ! -f ${1} ]]; then
        echo "The parameter is not a file"
        exit 2
    fi
    echo "Izgraden"
    exit 0
    else
        zavisimost=$(cat ${bakerfile} | grep -E "^${currDepend}:" | cut -d ':' -f2)
        isNewer=false
        for curr in ${zavisimost}; do
            if [[ ${curr} -nt ${currDepend} ]]; then
                isNewer=true
            fi
            ./2024-SE-04.sh "${curr}"
        done
        if [[ ${isNewer} == true ]]; then
            command=$(cat ${bakerfile} | grep -E "^${currDepend}:" | cut -d ':' -f3)
            eval ${command}
        fi
fi
