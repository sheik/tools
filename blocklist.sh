#!/bin/bash
# Gets all public URLs from iblocklist and fetches them, combining them into one list

if [ -z "$1" ]; then
    echo "`basename $0`: No output file specified"
    echo "usage: blocklist.sh [file]"
    exit
fi

OUTFILE="$1"

# get a list of urls
LISTS=$(wget -O - "https://www.iblocklist.com/lists.php" | egrep "list\.iblocklist\.com" | cut -d"'" -f12 | uniq)

echo "" > "$OUTFILE"

# download and append to OUTFILE
for i in $LISTS; do
    wget -O - "$i" | gunzip >> "$OUTFILE" 
done

wc $OUTFILE
