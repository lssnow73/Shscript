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
	echo "               branch"
	echo "               tag"
	echo "               ..."
	echo "   <TAG_NAME>: Tag name if <BRANCH> is 'tag'. 'git tag'"
	echo "               PLOS-LS-V3.0.6.0.0-rc4"
	echo "               ..."
	echo "               branch name if <BRANCH> is 'branch'. 'git branch -a'"
	echo "               site_ti_kesco_sec"
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
	PLATFORM=LS
	CONFIG=CloudWhite-TiFRONT
elif [ "$PLATFORM" = "LSn" ] || [ "$PLATFORM" = "lsn" ]; then
	PLATFORM=LSn
	CONFIG=CloudWhite-TiFRONT-N
elif [ "$PLATFORM" = "SS" ] || [ "$PLATFORM" = "ss" ]; then
	PLATFORM=SS
	CONFIG=CloudWhite-TiFRONT-SS
elif [ "$PLATFORM" = "CS" ] || [ "$PLATFORM" = "cs" ]; then
	PLATFORM=CS
	CONFIG=CloudWhite-TiFRONT-CSn
elif [ "$PLATFORM" = "CSo" ] || [ "$PLATFORM" = "cso" ]; then
	PLATFORM=CSo
	CONFIG=CloudWhite-TiFRONT-CSo
else
	PLATFORM=LSn
	CONFIG=CloudWhite-TiFRONT-N	# Default Configuration
fi

# Use second argument for BRANCH

if [ $# -eq 2 ]; then
	BRANCH=$2

	if [ "$BRANCH" = "develop-TiFRONT" ] || [ "$BRANCH" = "develop" ] || [ "$BRANCH" = "dev" ]; then
		PREFIX="Dev"
		BRANCH=develop-TiFRONT
	elif [ "$BRANCH" = "release-TiFRONT" ] || [ "$BRANCH" = "release" ] || [ "$BRANCH" = "rel" ]; then
		PREFIX="Rel"
		BRANCH=release-TiFRONT
	elif [ "$BRANCH" = "site_ti_kesco" ] || [ "$BRANCH" = "kesco" ] || [ "$BRANCH" = "KESCO" ]; then
		PREFIX="KESCO"
		BRANCH=site_ti_kesco
	elif [ "$BRANCH" = "site_ti_kesco_sec" ] || [ "$BRANCH" = "kesco_sec" ] || [ "$BRANCH" = "KESCO_SEC" ]; then
		PREFIX="KESCOSEC"
		BRANCH=site_ti_kesco_sec
	elif [ "$BRANCH" = "tag" ] || [ "$BRANCH" = "Tag" ]; then
		func_usage
	else
		PREFIX="Branch"
	fi
	GIT_COMMAND="checkout BRANCH=$BRANCH"

elif [ $# -ge 3 ]; then
	BRANCH=$2
	if [ "$BRANCH" = "tag" ] || [ "$BRANCH" = "Tag" ]; then
		PREFIX="Tag"
		TAG_NAME=$3
		GIT_COMMAND="reset NAME=$TAG_NAME"
	elif [ "$BRANCH" = "branch" ] || [ "$BRANCH" = "BRANCH" ] || [ "$BRANCH" = "b" ]; then
		PREFIX="Branch"
		BRANCH=$3
		GIT_COMMAND="checkout BRANCH=$BRANCH"
	else
		PREFIX="Tag"
		TAG_NAME=PLOS-LS-V3.0.6.0.0-rc4
		GIT_COMMAND="reset NAME=$TAG_NAME"
	fi

	if [ $# -eq 4 ]; then
		DONOT_MAKE="yes"
	fi
	#GIT_COMMAND="checkout BRANCH=$TAG_NAME"
else
	PREFIX="Rel"	# Default prefix
	BRANCH=release-TiFRONT	# Default Branch
	GIT_COMMAND="checkout BRANCH=$BRANCH"
fi

if [ "$PREFIX" = "Tag" ]; then
	# POSTFIX e.g. 'V3.0.6.0.0-rc4'
	POSTFIX=`echo $TAG_NAME | awk -F- '{if(NF == 3) print $3;else print $3"-"$4}'`
else
	POSTFIX=`date +%Y%m%d`	# e.g. 20170619 Do you want to Hour? Use %H.
fi

DIR_NAME=$PREFIX'TiFRONT_'$PLATFORM'_'$POSTFIX

dir_count=0

while [ -e $DIR_NAME ]; do
	let "dir_count++"

	if [ $dir_count -gt 5 ]; then
		echo "Don't make project! You have many project directory."
		exit -1
	else
		echo "Exist directory $DIR_NAME. Add postfix '$dir_count '"
		DIR_NAME=$DIR_NAME'_'$dir_count
	fi
done

echo "Clone to Directory... $DIR_NAME"
echo "Git command... $GIT_COMMAND"

git clone git+ssh://${USER}@192.168.201.144/opt/git/plos_ls/build_plos/build.git $DIR_NAME
cd $PWD/$DIR_NAME && ./configure $CONFIG && sh export.sh clone && make $GIT_COMMAND

export USER=$LOGNAME

if [ "$DONOT_MAKE" != "yes" ]; then
	make &> /dev/null 2>> error.log
fi

