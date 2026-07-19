#!/bin/bash

find ~ -maxdepth 1 -mindepth 1 -type f -user "${whoami}" -exec chmod 664 {} \; > /dev/null 2>&1
