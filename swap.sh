#!/bin/bash
# prints swap for all procs

SUM=0
OVERALL=0

printf "%8s %8s %.16s\n" "PID" "TOTAL" "PROGRAM" 
for DIR in `find /proc/ -maxdepth 1 -type d | egrep "^/proc/[0-9]"` ; do
    PID=`echo $DIR | cut -d / -f 3`
    PROGNAME=`ps -p $PID -o comm --no-headers`
    for SWAP in `grep Swap $DIR/smaps 2>/dev/null| awk '{ print $2 }'`; do
        let SUM=$SUM+$SWAP
    done
    printf "%8s %8s %.16s\n" $PID $SUM $PROGNAME
    let OVERALL=$OVERALL+$SUM
    SUM=0
done

echo
echo "Total: $OVERALL KiB"
