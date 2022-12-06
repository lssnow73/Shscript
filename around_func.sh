#!/bin/bash

#
# file - around_func.sh
# This script has a feature that around function by special string.
#
# Author: lssnow
# Date: 2017.07.21
#
# Usage:
# around_func.sh <FILENAME> <STRING>
#
#

function func_usage {
    echo "Usage:"
    echo "around_func.sh <FILENAME> <STRING>"
    echo "    <FILENAME>: filename with .c"
	echo "                poe_ioctl.c"
    echo "                ..."
    echo " "
    echo "    <STRING>  : around funtion name"
    echo "                POE_FUNC_RENAME"
    echo "                ..."
    echo " "
    echo "Example:"
    echo "around_func.sh poe_ioctl.c POE_FUNC_RENAME"
    echo " "
    exit 1
}


# Need argument 2.
if [ $# -lt 2 ]; then
	func_usage
fi

echo "Args($#): $1 $2"

# Check file
if [ -e $1 ]; then
	echo "Exist source file"
else
	echo "Not Exist source file"
fi

# Check tags file
if [ -e tags ]; then
	echo "Exist tags file"
else
	ctags -R
fi


# Make function list
FUNC_LIST=`cat tags | grep $1 | awk -F' ' '{ if($NF == "f") print $1 }'`

if [ "$FUNC_LIST" == "" ]; then
	echo "Exist tags file but Not Exist function list in the file."
fi

for func in $FUNC_LIST
do
	echo "$func"
	sed -i 's/'$func'[^)]/'$2'('$func')(/g' `find . -name $1`
done


