PLATFORM=$1
BRANCH=$2
CONFIGURE=$3
VER1=$4
VER2=$5
VER3=$6
VER4=$7
VER5=$8
VER6=$9

#check version
if [ "$PLATFORM" == "" ] || [ "$VER1" = "" ] || [ "$VER2" = "" ] || [ "$VER3" = "" ] || [ "$VER4" = "" ] || [ "$VER5" = "" ] ; then
echo usage : sh auto.sh platform branch configure ver1 ver2 ver3 ver4 ver5 ver6
exit 0
fi

#check platform state
if [ "$PLATFORM" = "ALL" ] ; then
	if [ "$BRANCH" = "" ] ; then
		echo error Not set branch ...
		exit 0
	fi

else
	if [ "$BRANCH" = "" ] ; then
		echo error Not set branch ...
		exit 0
	fi
	if [ "$CONFIGURE" = "" ] ; then
		echo error Not set configure ...
		exit 0
	fi
fi


#build plos
if [ "$PLATFORM" = "ALL" ] ; then

echo All Flatform Compile... branch : $BRANCH 
echo Version : PLOS-$PLATFORM-V$VER1.$VER2.$VER3.$VER4.$VER5-rc$VER6
echo START !!!!

git clone git+ssh://192.168.201.144/opt/git/plos_ls/build_plos/build.git LS
git clone git+ssh://192.168.201.144/opt/git/plos_ls/build_plos/build.git LSn
git clone git+ssh://192.168.201.144/opt/git/plos_ls/build_plos/build.git SS
git clone git+ssh://192.168.201.144/opt/git/plos_ls/build_plos/build.git CS
git clone git+ssh://192.168.201.144/opt/git/plos_ls/build_plos/build.git CSo

cd $PWD/LS && ./configure CloudWhite-TiFRONT && sh export.sh clone && make checkout BRANCH=$BRANCH
sed -i 's/PLOS_OS_VER1 = 1/PLOS_OS_VER1 = '$VER1'/' config.make
sed -i 's/PLOS_OS_VER2 = 0/PLOS_OS_VER2 = '$VER2'/' config.make
sed -i 's/PLOS_OS_VER3 = 0/PLOS_OS_VER3 = '$VER3'/' config.make
sed -i 's/PLOS_OS_VER4 = 0/PLOS_OS_VER4 = '$VER4'/' config.make
sed -i 's/PLOS_OS_VER5 = 0/PLOS_OS_VER5 = '$VER5'/' config.make
if [ "$VER6" != "" ] ; then
sed -i 's/PLOS_OS_VER6 = 0/PLOS_OS_VER6 = '$VER6'/' config.make
fi
make &> /dev/null 2>> error.log
cd ..

cd $PWD/LSn && ./configure CloudWhite-TiFRONT-N && sh export.sh clone && make checkout BRANCH=$BRANCH
sed -i 's/PLOS_OS_VER1 = 1/PLOS_OS_VER1 = '$VER1'/' config.make
sed -i 's/PLOS_OS_VER2 = 0/PLOS_OS_VER2 = '$VER2'/' config.make
sed -i 's/PLOS_OS_VER3 = 0/PLOS_OS_VER3 = '$VER3'/' config.make
sed -i 's/PLOS_OS_VER4 = 0/PLOS_OS_VER4 = '$VER4'/' config.make
sed -i 's/PLOS_OS_VER5 = 0/PLOS_OS_VER5 = '$VER5'/' config.make
if [ "$VER6" != "" ] ; then
sed -i 's/PLOS_OS_VER6 = 0/PLOS_OS_VER6 = '$VER6'/' config.make
fi
make &> /dev/null 2>> error.log
cd ..

cd $PWD/SS && ./configure CloudWhite-TiFRONT-SS && sh export.sh clone && make checkout BRANCH=$BRANCH
sed -i 's/PLOS_OS_VER1 = 1/PLOS_OS_VER1 = '$VER1'/' config.make
sed -i 's/PLOS_OS_VER2 = 0/PLOS_OS_VER2 = '$VER2'/' config.make
sed -i 's/PLOS_OS_VER3 = 0/PLOS_OS_VER3 = '$VER3'/' config.make
sed -i 's/PLOS_OS_VER4 = 0/PLOS_OS_VER4 = '$VER4'/' config.make
sed -i 's/PLOS_OS_VER5 = 0/PLOS_OS_VER5 = '$VER5'/' config.make
if [ "$VER6" != "" ] ; then
sed -i 's/PLOS_OS_VER6 = 0/PLOS_OS_VER6 = '$VER6'/' config.make
fi
make &> /dev/null 2>> error.log
cd ..

cd $PWD/CS && ./configure CloudWhite-TiFRONT-CSn && sh export.sh clone && make checkout BRANCH=$BRANCH
sed -i 's/PLOS_NOS_VER1 = 1/PLOS_NOS_VER1 = '$VER1'/' config.make
sed -i 's/PLOS_NOS_VER2 = 0/PLOS_NOS_VER2 = '$VER2'/' config.make
sed -i 's/PLOS_NOS_VER3 = 0/PLOS_NOS_VER3 = '$VER3'/' config.make
sed -i 's/PLOS_NOS_VER4 = 0/PLOS_NOS_VER4 = '$VER4'/' config.make
sed -i 's/PLOS_NOS_VER5 = 0/PLOS_NOS_VER5 = '$VER5'/' config.make
if [ "$VER6" != "" ] ; then
sed -i 's/PLOS_NOS_VER6 = 0/PLOS_NOS_VER6 = '$VER6'/' config.make
fi
sed -i 's/PLOS_APP_VER1 = 1/PLOS_APP_VER1 = '$VER1'/' config.make
sed -i 's/PLOS_APP_VER2 = 0/PLOS_APP_VER2 = '$VER2'/' config.make
sed -i 's/PLOS_APP_VER3 = 0/PLOS_APP_VER3 = '$VER3'/' config.make
sed -i 's/PLOS_APP_VER4 = 0/PLOS_APP_VER4 = '$VER4'/' config.make
sed -i 's/PLOS_APP_VER5 = 0/PLOS_APP_VER5 = '$VER5'/' config.make
if [ "$VER6" != "" ] ; then
sed -i 's/PLOS_APP_VER6 = 0/PLOS_APP_VER6 = '$VER6'/' config.make
fi
sed -i 's/PLOS_XQC_VER1 = 1/PLOS_XQC_VER1 = '$VER1'/' config.make
sed -i 's/PLOS_XQC_VER2 = 0/PLOS_XQC_VER2 = '$VER2'/' config.make
sed -i 's/PLOS_XQC_VER3 = 0/PLOS_XQC_VER3 = '$VER3'/' config.make
sed -i 's/PLOS_XQC_VER4 = 0/PLOS_XQC_VER4 = '$VER4'/' config.make
sed -i 's/PLOS_XQC_VER5 = 0/PLOS_XQC_VER5 = '$VER5'/' config.make
if [ "$VER6" != "" ] ; then
sed -i 's/PLOS_XQC_VER6 = 0/PLOS_XQC_VER6 = '$VER6'/' config.make
fi
make &> /dev/null 2>> error.log
cd ..

cd $PWD/CSo && ./configure CloudWhite-TiFRONT-CSo && sh export.sh clone && make checkout BRANCH=$BRANCH
sed -i 's/PLOS_OS_VER1 = 1/PLOS_OS_VER1 = '$VER1'/' config.make
sed -i 's/PLOS_OS_VER2 = 0/PLOS_OS_VER2 = '$VER2'/' config.make
sed -i 's/PLOS_OS_VER3 = 0/PLOS_OS_VER3 = '$VER3'/' config.make
sed -i 's/PLOS_OS_VER4 = 0/PLOS_OS_VER4 = '$VER4'/' config.make
sed -i 's/PLOS_OS_VER5 = 0/PLOS_OS_VER5 = '$VER5'/' config.make
if [ "$VER6" != "" ] ; then
sed -i 's/PLOS_OS_VER6 = 0/PLOS_OS_VER6 = '$VER6'/' config.make
fi
make &> /dev/null 2>> error.log
cd ..

else #LS or LSn ...

echo $PLATFORM Compile... branch : $BRANCH
echo Version : PLOS-$PLATFORM-V$VER1.$VER2.$VER3.$VER4.$VER5-rc$VER6
echo START !!!!

git clone git+ssh://192.168.201.144/opt/git/plos_ls/build_plos/build.git $PLATFORM

cd $PWD/$PLATFORM && ./configure $CONFIGURE && sh export.sh clone && make checkout BRANCH=$BRANCH
sed -i 's/PLOS_OS_VER1 = 1/PLOS_OS_VER1 = '$VER1'/' config.make
sed -i 's/PLOS_OS_VER2 = 0/PLOS_OS_VER2 = '$VER2'/' config.make
sed -i 's/PLOS_OS_VER3 = 0/PLOS_OS_VER3 = '$VER3'/' config.make
sed -i 's/PLOS_OS_VER4 = 0/PLOS_OS_VER4 = '$VER4'/' config.make
sed -i 's/PLOS_OS_VER5 = 0/PLOS_OS_VER5 = '$VER5'/' config.make
if [ "$VER6" != "" ] ; then
sed -i 's/PLOS_OS_VER6 = 0/PLOS_OS_VER6 = '$VER6'/' config.make
fi
make &> /dev/null 2>> error.log
cd ..

fi






#tagging
#make tag NAME=PLOS-LS-V2.0.16.0.15-rc1 COMMENT="PLOS-LS-V2.0.16.0.15-rc1 Release" && make tag-push NAME=PLOS-LS-V2.0.16.0.15-rc1
