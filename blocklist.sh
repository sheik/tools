#!/bin/bash
# Gets all public URLs from iblocklist and fetches them, combining them into one list
# Copyright (c) Jeff Aigner 2014

PROG=`basename $0`

HTTPD_USER="root"

cat /etc/passwd | cut -d':' -f1 | grep apache &> /dev/null
if [[ $? -eq 0 ]]; then
    HTTPD_USER="apache"
fi    

cat /etc/passwd | cut -d':' -f1 | grep httpd &> /dev/null
if [[ $? -eq 0 ]]; then
    HTTPD_USER="httpd"
fi    

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

echo "[*] Retrieving blocklists from iblocklist.com"

# get a list of urls
LISTS=$(wget -q -O - "https://www.iblocklist.com/lists.php" | egrep "list\.iblocklist\.com" | cut -d"'" -f12 | uniq)

# clear output file
echo "" > "$OUTFILE"

# download all lists and append to OUTFILE
n=1
for i in $LISTS; do
    echo "[*] Fetching blocklist $n"
    wget -q -O - "$i" | gunzip >> "$OUTFILE"
    n=$(($n + 1))
done

echo "[*] Compressing master blocklist"

# compress and replace old file
gzip -c $OUTFILE > $OUTFILE.new.gz

echo "[*] Cleaning up"
rm $OUTFILE
mv $OUTFILE.new.gz $OUTFILE.gz

chmod 640 $OUTFILE.gz
chown root:$HTTPD_USER $OUTFILE.gz

echo "[*] Complete!"

exit 0
