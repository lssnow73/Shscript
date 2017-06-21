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
	echo "clone_repository.sh <PLATFORM> <BRANCH> <TAG_NAME>"
	echo "   <PLATFORM>: TiFRONT Platform abbreviation"
	echo "               LS          CloudWhite-TiFRONT"
	echo "               LSn         CloudWhite-TiFRONT-N"
	echo "               SS          CloudWhite-TiFRONT-SS"
	echo "               CS          CloudWhite-TiFRONT-CSn"
	echo "               CSo         CloudWhite-TiFRONT-CSo"
	echo " "
	echo "   <BRANCH>  : Git Branch name 'git branch -a'"
	echo "               develop-TiFRONT"
	echo "               release-TiFRONT"
	echo "               site_ti_kesco"
	echo "               tag"
	echo "               ..."
	echo "   <TAG_NAME>: Tag name if <BRANCH> is 'tag'. 'git tag'"
	echo "               PLOS-LS-V3.0.6.0.0-rc4"
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
	elif [ "$BRANCH" = "tag" ] || [ "$BRANCH" = "Tag" ]; then
		func_usage
	else
		PREFIX="Dev"
		BRANCH=develop-TiFRONT	# Default Branch
	fi

	GIT_COMMAND="checkout BRANCH=$BRANCH"

elif [ $# -eq 3 ]; then
	BRANCH=$2
	if [ "$BRANCH" = "tag" ] || [ "$BRANCH" = "Tag" ]; then
		TAG_NAME=$3
	else
		TAG_NAME=PLOS-LS-V3.0.6.0.0-rc4
	fi
	PREFIX="Tag"
	GIT_COMMAND="reset NAME=$TAG_NAME"
else
	PREFIX="Dev"	# Default prefix
	BRANCH=develop-TiFRONT	# Default Branch
	GIT_COMMAND="checkout BRANCH=$BRANCH"
fi

if [ "$PREFIX" = "Tag" ]; then
	POSTFIX=`echo $TAG_NAME | awk -F- '{if(NR == 1) print $3"-"$4}'`
else
	POSTFIX=`date +%Y%m%d`	# e.g. 20170619 Do you want to Hour? Use %H.
fi

DIR_NAME=$PREFIX'TiFRONT_'$PLATFORM'_'$POSTFIX

if [ -e $DIR_NAME ]; then
	sudo rm -rf $DIR_NAME
fi

echo "Clone to Directory... $DIR_NAME"
echo "Git command... $GIT_COMMAND"

git clone git+ssh://${USER}@192.168.201.144/opt/git/plos_ls/build_plos/build.git $DIR_NAME
cd $PWD/$DIR_NAME && ./configure $CONFIG && sh export.sh clone && make $GIT_COMMAND

export USER=$LOGNAME

make &> /dev/null 2>> error.log

