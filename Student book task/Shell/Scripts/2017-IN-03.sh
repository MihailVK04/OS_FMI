#!/bin/bash

lastModified=$(find /home/students -type f -printf "%u %p %T@ %f\n" 2>/dev/n
echo ${lastModified}
name=$(echo "$lastModified}" | cut -d ' ' -f1)
echo "Username: ${name}"
fileName=$(echo "${lastModified}" | cut -d ' ' -f4)
echo "Filename: ${fileName}"
