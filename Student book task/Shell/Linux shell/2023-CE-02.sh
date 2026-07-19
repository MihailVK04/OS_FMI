#!/bin/bash

find /var/log/my_logs -maxdepth 1 -type f -regextype posix-extended -regex '.*/[A-Za-z0-9_]+_[0-9]+\.log' -exec grep -o '\berror\b' {} + | wc -l
