#!/bin/bash

#
# file - clone_repository.sh
# This script has a feature that clone repository.
#
# Author: lssnow
# Date: 2017.06.19
#
# Usage:
#
# clone_repository.sh <PLATFORM> <BRANCH>
# 
#	<PLATFORM>: LS			CloudWhite-TiFRONT
#				LSn			CloudWhite-TiFRONT-N
#				SS			CloudWhite-TiFRONT-SS
#				CS			CloudWhite-TiFRONT-CSn
#				CSo			CloudWhite-TiFRONT-CSo
#
#	<BRANCH>:	develop-TiFRONT
#				release-TiFRONT
#				...
#

function func_usage {
	echo "Usage:"
	echo "clone_repository.sh <PLATFORM> <BRANCH>"
	echo "   <PLATFORM>: LS          CloudWhite-TiFRONT"
	echo "               LSn         CloudWhite-TiFRONT-N"
	echo "               SS          CloudWhite-TiFRONT-SS"
	echo "               CS          CloudWhite-TiFRONT-CSn"
	echo "               CSo         CloudWhite-TiFRONT-CSo"
	echo " "
	echo "   <BRANCH>  : develop-TiFRONT"
	echo "               release-TiFRONT"
	echo "               site_ti_kesco"
	echo "               ..."
	exit 1
}

if [ $# -lt 1 ]; then
	func_usage
fi

USER=sslee	# for Git User

# Use second argument for BRANCH
PLATFORM=$1
if [ "$PLATFORM" = "LS" ] || [ "$PLATFORM" = "ls" ]; then
	CONFIG=CloudWhite-TiFRONT
elif [ "$PLATFORM" = "LSn" ] || [ "$PLATFORM" = "lsn" ]; then
	CONFIG=CloudWhite-TiFRONT-N
elif [ "$PLATFORM" = "SS" ] || [ "$PLATFORM" = "ss" ]; then
	CONFIG=CloudWhite-TiFRONT-SS
elif [ "$PLATFORM" = "CS" ] || [ "$PLATFORM" = "cs" ]; then
	CONFIG=CloudWhite-TiFRONT-SS
elif [ "$PLATFORM" = "CSo" ] || [ "$PLATFORM" = "cso" ]; then
	CONFIG=CloudWhite-TiFRONT-SS
else
	CONFIG=CloudWhite-TiFRONT-N	# Default Configuration
fi

# Use second argument for BRANCH
if [ $# -eq 2 ]; then
	BRANCH=$2

	if [ "$BRANCH" = "develop-TiFRONT" ]; then
		PREFIX="Dev"
		BRANCH=develop-TiFRONT
	elif [ "$BRANCH" = "release-TiFRONT" ]; then
		PREFIX="Rel"
		BRANCH=release-TiFRONT
	elif [ "$BRANCH" = "site_ti_kesco" ] || [ "$BRANCH" = "kesco" ]; then
		PREFIX="KESCO"
		BRANCH=site_ti_kesco
	else
		PREFIX="Dev"
		BRANCH=develop-TiFRONT	# Default Branch
	fi
else
	PREFIX="Dev"	# Default prefix
	BRANCH=develop-TiFRONT	# Default Branch
fi

POSTFIX=`date +%Y%m%d`	# e.g. 20170619 Do you want to Hour? Use %H.
DIR_NAME=$PREFIX'TiFRONT_'$PLATFORM'_'$POSTFIX

if [ -e $DIR_NAME ]; then
	sudo rm -rf $DIR_NAME
fi

echo "Clone to Directory... $DIR_NAME"
git clone git+ssh://${USER}@192.168.201.144/opt/git/plos_ls/build_plos/build.git $DIR_NAME
cd $PWD/$DIR_NAME && ./configure $CONFIG && sh export.sh clone && make checkout BRANCH=$BRANCH

export USER=$LOGNAME

make &> /dev/null 2>> error.log

