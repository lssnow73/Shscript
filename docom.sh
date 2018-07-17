#!/bin/bash

#
# file - docom.sh
# This script is docker-compose up for mtkdev, cortdev, qtnadev.
#
# Author: lssnow
# Date: 2018.07.17
#
# Usage:
# docom <DEV_NAME>
#

function func_usage {
    echo "Usage:"
    echo "docom <DEV_NAME> <ACTION>"
    echo "      <DEV_NAME>: cort"
    echo "                  mtk"
    echo "                  qtna"
    echo "      <ACTION>  : down"
    echo "                  up"
    echo " "
    echo "Example:"
    echo "docom mtk"
    echo " "
}


# Need Argument
if [ $# -lt 1 ]; then
	func_usage
    exit 1
fi

if [ $1 == "cort" ]; then
	CON_NAME=cortdev
elif [ $1 == "mtk" ]; then
	CON_NAME=mtkdev
elif [ $1 == "qtna" ]; then
	CON_NAME=qtnadev
else
	func_usage
	exit 1
fi

#echo "ARGS($#) $0 $1 $CON_NAME.yml"

CON_CHECK_LIST=`sudo docker ps | awk -v con_name="${CON_NAME}" \
		  '{ if($NF == con_name) {print "Exist"} else {print "NotExist"} }'`
for list in $CON_CHECK_LIST
do
	if [ $list == "Exist" ]; then
		CON_EXIST="Exist"
	else
		CON_EXIST="NotExist"
	fi
done
#echo "ARGS($#) $0 $1 $CON_NAME.yml $CON_CHECK_LIST $CON_EXIST"

if [ $# -lt 2 ]; then
	if [ $CON_EXIST == "Exist" ]; then
		echo "Exist same container name"
		exit 1
	fi
	sudo docker-compose -p $CON_NAME -f $CON_NAME.yml up -d
else
	if [ $2 == "down" ]; then
		if [ $CON_EXIST == "Exist" ]; then
			sudo docker-compose -p $CON_NAME -f $CON_NAME.yml down
		else
			echo "Not Exist container"
		fi
	else
		if [ $CON_EXIST == "Exist" ]; then
			echo "Exist same container name"
			exit 1
		fi
		sudo docker-compose -p $CON_NAME -f $CON_NAME.yml up -d
	fi
fi

