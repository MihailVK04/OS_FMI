#!/bin/bash

site=$(tail -n +2 spacex.txt | awk -F'|' '$3 == "Failure" { count[$2]++ } END {
    max = 0
    for (s in count) if (count[s] > max) { max = count[s]; best = s }
    print best
}')

tail -n +2 spacex.txt | awk -F'|' -v site="${site}" '$2 == site' | sort -t'|' -k1 -n -r | head -n 1 | cut -d'|' -f3,4 | tr '|' ':'
