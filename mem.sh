#!/bin/bash
# print user memory usage totals

for USER in $(ps haux | awk '{print $1}' | sort -u)
do
    printf "%10s %%" $USER
    ps -o "pid,user,pcpu,pmem,vsz" -U $USER | awk '{ SUM += $4 } END { print SUM}'
done

