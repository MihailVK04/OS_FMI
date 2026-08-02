#!/bin/bash

if [[ $(whoami) != "oracle" ]] || [[ $(whoami) != "grid" ]]; then
    echo "You are not the expected user"
    exit 1
fi

if [[ -z ${ORACLE_HOME} ]]; then
    echo "No local directory in env"
    exit 2
fi

exeFile="${ORACLE_HOME}/bin/adrci"
home="/u01/app/$(whoami)"
commandOutput=$(mktemp)
${exeFile} exec="show homes" >> ${commandOutput}
if ! grep -q -E "^No\b" "${commandOutput}"; then
    while read -r line; do
        path="${home}/{line}"
        bytes=$(stat -c "%s" "${path}")
        mb_size=$(echo "scale=2; ${bytes}/1024/1024" | bc)
        echo "${mb_size} ${path}"
    done< <(cat "${commandOutput}" | tail -n +2 | tr -s ' ' | sed -E "s:^\ *::g")
fi

rm ${commandOutput}
