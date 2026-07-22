#!/bin/bash

if [[ ${#} -lt 1 || ${#} -gt 2 ]]; then
    echo "Parameters must be 1 or 2"
    exit 1
fi

if [[ ! -d ${1} ]]; then
     echo "Parameter is not a directory"
     exit 2
fi

if [[ -n ${2} && ${2} =~ ^[1-9]+[0-9]*$ ]]; then
    find ${1} -type f \( -links +${2} -o -links ${2} \)
else
    find -L ${1} -type l
fi
