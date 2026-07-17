#!/bin/bash

find ~ -type f -printf '%s %p\n' 2>/dev/null | sort -rn | head -n 5 | cut -d ' ' -f2- | while read -r file; do
    rm -f "${file}"
done
