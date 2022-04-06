#!/bin/bash

echo "Save counter at file"

FILENAME="stats_save_file.txt"
TEST_DATE=`date +%F_%T`

if [ -w $FILENAME ]; then
	echo "$FILENAME exist. So, Read Counter"
	CNT=`tail -n 1 $FILENAME | awk '{print $1}'`
	CNT=`expr $CNT + 1`
	echo "Write counter $CNT to $FILENAME"
	awk -v cnt="$CNT" -v date="$TEST_DATE" 'BEGIN {printf "%5d  %s\n", cnt, date}' >> $FILENAME
else
	echo "$FILENAME not exist. So, Create File"
	CNT=1
	awk -v cnt="$CNT" -v date="$TEST_DATE" 'BEGIN {printf "%5d  %s\n", cnt, date}' > $FILENAME
fi

