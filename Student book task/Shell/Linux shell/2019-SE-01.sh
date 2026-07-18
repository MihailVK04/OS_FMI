#!/bin/bash

farType=$(tail -n +2 planets.txt | sort -t';' -k3 -n -r | head -n 1 | cut -d';' -f2)

tail -n +2 planets.txt | awk -F';' -v type="${farType}" '$2 == type' | sort -t';' -k3 -n | head -n 1 | cut -d';' -f1,4 | tr ';' '\t'
