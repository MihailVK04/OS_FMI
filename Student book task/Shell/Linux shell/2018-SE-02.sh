#!/bin/bash

find /home/pesho -type f -links +1 -printf '%T@ %i\n' | sort -rn | head -n 1 | cut -d ' ' -f2
