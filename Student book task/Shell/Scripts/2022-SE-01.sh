#!/bin/bash

if [[ ${#} -ne 3 ]]; then
    echo "The script needs 3 parameters"
    exit 1
fi

if [[ ! ${1} =~ ^[0-9]+\.?[0-9]*$ ]]; then
    echo "First parameter is not a number"
    exit 2
fi

if grep -E -q ",${2}," "prefix.csv"; then
    number=$(grep -E ",${2}," "prefix.csv" | cut -d ',' -f3)

    if grep -E -q ",${3}," "base.csv"; then
        type=$(grep -E ",${3}," "base.csv" | cut -d ',' -f3)
        name=$(grep -E ",${3}," "base.csv" | cut -d ',' -f1)

        calculated=$(echo "scale=1; ${1} * ${number}" |  bc)
        echo "${calculated} ${3} (${type}, ${name})"
    else
        echo "There is no such unit symbol"
        exit 3
    fi
else
    echo "There is no such prefix symbol"
    exit 4
fi
