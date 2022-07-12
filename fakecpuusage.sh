#!/bin/bash

FILENAME=/home/lssnow/test/cpuusage

while true
do
	/usr/bin/inotifywait -qq -e close_write $FILENAME; rv=$?

	if [ $rv -eq 0 ]; then
		echo `awk 'END{fake=$1 * 0.85; printf "%d\n", fake}' $FILENAME` > $FILENAME
	fi
done

