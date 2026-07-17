#!/bin/bash

count = $(find / -user "${whoami}" 2>/dev/null | wc -l)

echo "Броят на обектите е ${count}"
