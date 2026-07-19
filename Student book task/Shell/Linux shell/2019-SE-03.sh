#!/bin/bash

inode=$(find /home/velin -type f -printf '%T@ %i\n' | sort -rn | head -n 1 | cut -d ' ' -f2)

find /home/velin -type f -inum "${inode}" -printf '%p\n' | awk -F'/' '{print NF-1}' | sort -n | head -n 1
