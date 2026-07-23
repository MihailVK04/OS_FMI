#!/bin/bash

if [[ $(id -u) -ne 0 ]]; then
    echo "You are not root"
    exit 1
fi

alreadyCheckedUsers=$(mktemp)
maxMemoryRoot=$(ps -u root -o rss= | awk '{sum+=${1}} END {print sum}')
while read -r pid user rss; do
    if grep -q -e "${user}" ${alreadyCheckedUsers}; then
        continue
    fi
    homeDir=$(cat /etc/passwd | grep ${user} | cut -d ':' -f6)
    if [[ -z ${homeDir} ]]; then
        continue
    fi
    ownerOfHomeDir=$(stat -c "%U" ${homeDir})
    permissions=$(stat -c "%A" ${homeDir})
    echo "Homedir: ${homeDir}"
    echo "OwnerOfHomeDir: ${ownerOfHomeDir}"
    echo "Permissions: ${permissions}"
    echo "Current User: ${user}"
    if [[ ! -d ${homeDir} || ${user} != ${ownerOfHomeDir} || ${permissions:2:1} != "w" ]];then
        currentUserMemory=$(ps -u ${user} -o rss= | awk '{sum+=$1} END {print sum}')
        echo "Im in: ${user} with ${currentUserMemory} > ${maxMemoryRoot}"
        if [[ ${currentUserMemory} -gt ${maxMemoryRoot} ]]; then
            echo "Kill user: ${user}"
            killall -u ${user}
        fi
    fi
    echo "${user}" >> ${alreadyCheckedUsers}
done< <(ps -u root -o pid=,user=,rss= -N)

rm ${alreadyCheckedUsers}
