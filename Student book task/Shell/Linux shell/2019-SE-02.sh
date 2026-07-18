#!/bin/bash

find /home/SI -maxdepth 1 -mindepth 1 -type d -newerct @1551168000 ! -newerc  @1551176100 | while read -r dir; do
    user=$(basename "${dir}")
    facNum=$(echo "${user}" | cut -c2-)
    gecos=$(grep "^${user}:" /etc/passwd | cut -d: -f5)
    name=$(echo "${gecos}" | cut -d',' -f1)
    echo -e "${facNum}\t${name}"
done | sort -n
