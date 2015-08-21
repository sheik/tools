#!/bin/bash
# Gets all public URLs from iblocklist and fetches them, combining them into one list
# Copyright (c) Jeff Aigner 2014

PROG=`basename $0`

# check for args
if [ -z "$1" ]; then
    echo "$PROG: No output file specified"
    echo "usage: $PROG [file]"
    exit 1
fi

# check for required commands 
CMDS=( wget gzip chmod rm )

for c in "${CMDS[@]}"; do 
    command -v "$c" > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo "$PROG: Unable to find $c. Please install it to continue."
        exit 1
    fi
done

OUTFILE="$1"

# get a list of urls
LISTS=$(wget -O - "https://www.iblocklist.com/lists.php" | egrep "list\.iblocklist\.com" | cut -d"'" -f12 | uniq)

# clear output file
echo "" > "$OUTFILE"

# download all lists and append to OUTFILE
for i in $LISTS; do
    wget -O - "$i" | gunzip >> "$OUTFILE" 
done

# compress and replace old file
gzip -c $OUTFILE > $OUTFILE.new.gz
rm $OUTFILE
mv $OUTFILE.gz $OUTFILE.gz.last

mv $OUTFILE.new.gz $OUTFILE.gz
chmod 640 $OUTFILE.gz
chown root:apache $OUTFILE.gz

exit 0
