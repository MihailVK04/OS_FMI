#!/bin/bash

cat etc/passwd | grep -E '^s[0-9]+:' | grep 'Inf' | grep -E ' [A-Za-z]*a[,:]' | cut -d: -f1 | cut -c3-4 | sort | uniq -c | sort -rn | head -n 1 | tr -s ' '
