#!/bin/bash

gid=$(sort -t: -k3 -n /etc/passwd | sed -n '201p' | cut -d: -f4)

awk -F: -v gid="${gid}" '$4 == gid {
    split($5, nameArr, ",")
    name = nameArr[1]
    gsub(/^[ \t]+|[ \t]+$/, "", name)
    print substr($1, 2), name ":" $6
}' /etc/passwd | sort -n | cut -d ' ' -f2-
