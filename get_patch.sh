#!/bin/bash

# file - get_patch.sh
# This script is get linux patch file "patch-4.14.OOO.xz" use wget
# from https://mirrors.edge.kernel.org/pub/linux/kernel/v4.x/
#
# Author: lssnow
# Date: 2020.01.17
#
# Usage:
#        ./get_patch.sh <START> <END>
#
#      START: 91 at patch-4.14.91.xz
#      END  : 165 at patch-4.14.165.xz
#

function func_usage {
	echo "Usage:"
	echo "./get_patch.sh <START> <END>"
	echo "		<START> 91 at patch-4.14.91.xz"
	echo "		<END>	165 at patch-4.14.165.xz"

	exit 1
}

# Need argument 2.
if [ $# -lt 2 ]; then
	func_usage
fi

echo "Args($#): $1 $2"

CMDLINE="wget --no-check-certificate https://mirrors.edge.kernel.org/pub/linux/kernel/v4.x/"

count=$1

while [ $count -le $2 ]; do
	if [ $count -lt 10 ]; then
		SUBLEVEL=00$count
	elif [ $count -lt 100 ]; then
		SUBLEVEL=0$count
	else
		SUBLEVEL=$count
	fi
	PATCH_FILE=patch-4.14.$count.xz
	OUTPUT_FILE=patch-4.14.$SUBLEVEL.xz
	$CMDLINE$PATCH_FILE -O $OUTPUT_FILE
	let "count++"
done

