#!/bin/bash

find / -type f -user "${whoami}" -regextype posis-extended -regex '.*\.blend[0-9]+' 2>/dev/null
