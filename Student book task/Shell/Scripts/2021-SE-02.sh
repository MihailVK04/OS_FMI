#!/bin/bash

isFQDN() {
    if [[ $1 =~ ^[^.][a-z0-9\.]*\.$ ]]; then
        if [[ $1 =~ (\.\.)+ ]]; then
            return 2
        else
            return 0
        fi
    fi
    return 1
}

isNumber() {
    if [[ $1 =~ ^[1-9]+[0-9]*$ ]] || [[ $1 == "" ]]; then
        return 0
    fi
    return 1
}

isType() {
    [[ $1 =~ ^(SOA|NS|A|AAAA)$ ]]
}

isCorrectFormat() {
    FQDN=$(cat ${file} | cut -d ' ' -f1)
    if ! isFQDN ${FQDN}; then
        echo "FQDN is not correct: ${FQDN}"
        return 1
    fi
    TTL=$(cat ${file} | cut -d ' ' -f2)
    if ! isNumber ${TTL}; then
        echo "TTL is not a number: ${TTL}"
        return 2
    fi
    class=$(cat ${file} | cut -d ' ' -f3)
    if [[ ${class} != "IN" ]]; then
        echo "Class is not correct"
        return 3
    fi
    type=$(cat ${file} | cut -d ' ' -f4)
    if ! isType ${type}; then
        echo "Type is not correct: ${type}"
        return 4
    fi
    Rdata1=$(cat ${file} | cut -d ' ' -f5)
    Rdata2=$(cat ${file} | cut -d ' ' -f6)
    if ! isFQDN ${Rdata1} || ! isFQDN ${Rdata2}; then
        echo "Rdata1 or Rdata2 is not FQDN ${Rdata1} - ${Rdata2}"
        return 5
    fi
}
for file in "${@}"; do
    serial=""
    if [[ $(cat ${file} | wc -l) -eq 1 ]]; then
        if ! isCorrectFormat; then
            continue
        fi
        serial=$(cat ${file} | cut -d ' ' -f7)
        echo "${serial}"
    else
        if ! isCorrectFormat; then
            continue
        fi
        serial=$(cat ${file} | grep -E "; serial" | cut -d ';' -f1 | tr -s ' ' | tr -d ' ')
        echo "${serial}"
    fi
    currDate=$(date "+%Y%m%d")
    echo "currDate: ${currDate}, Length: ${currDate}"
    fileDate=${serial:0:-2}
    echo "Serial: ${serial}"
    if [[ ${currDate} -gt ${fileDate} ]]; then
        sed -E -i "s:${serial}:${currDate}00:g" ${file}
    fi
    if [[ ${currDate} -eq ${fileDate} ]]; then
        newserial=$(echo "${serial} + 1" | bc)
        sed -E -i "s:${serial}:${newserial}:g" ${file}
    fi
done
