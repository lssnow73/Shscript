#!/bin/bash

echo -n "Power ON/OFF TEST Start..."

if [ $SCRIPT_PROGESS ]; then
	if [ $SCRIPT_PROGESS == 1 ]; then
		exit 0
	fi
fi

export SCRIPT_PROGESS=1

PCIe_NUM=28
FILENAME="/secui/data/PowerON_OFF_TEST.txt"
MACRO_SLEEP=let
#MACRO_SLEEP=sleep
CMD_SHORT_SLEEP=1
BRIDGE_CHECK_SLEEP=5
TRAFFIC_CHECK_SLEEP=30

SECONDS_OF_DAY=86400
SECONDS_OF_HOUR=3600
SECONDS_OF_MINUTE=60

START_TIME=`date`
START_TIME_sec=`date +%s`
START_TEST_DATE=`date +%F_%T`

if [ -w $FILENAME ]; then
	TEST_CNT=`tail -n 1 $FILENAME | awk '{print $1}'`
	TEST_CNT=`expr $TEST_CNT + 1`
	TEST_FAIL_CNT=`tail -n 1 $FILENAME | awk '{print $2}'`
else
	TEST_CNT=1
	TEST_FAIL_CNT=0
	touch $FILENAME
fi

echo "$TEST_CNT"

PCIe_DETECT_NUM=`/usr/sbin/lspci -tvnn | wc -l`

if [ $PCIe_NUM == $PCIe_DETECT_NUM ]; then
	PCIe_Pass=1
else
	PCIe_Pass=0
fi

$MACRO_SLEEP $CMD_SHORT_SLEEP

#/root/br.sh

$MACRO_SLEEP $BRIDGE_CHECK_SLEEP

INTERFACE_NUM=13
INTERFACE_DETECT_NUM=`/usr/sbin/ip link show | grep eth[0-9] | wc -l`

if [[ $INTERFACE_NUM == $INTERFACE_DETECT_NUM ]]; then
	INTERFACE_Pass=1
else
	INTERFACE_Pass=0
fi

if [[ $PCIe_Pass == 0 || $INTERFACE_Pass == 0 ]]; then
	TEST_FAIL_CNT=`expr $TEST_FAIL_CNT + 1`
fi

END_TEST_DATE=`date +%F_%T`

awk -v tc="$TEST_CNT" -v tfc="$TEST_FAIL_CNT" -v std="$START_TEST_DATE" -v etd="$END_TEST_DATE" \
    -v pp="$PCIe_Pass" -v ip="$INTERFACE_Pass" -v pdn="$PCIe_DETECT_NUM" \
	-v idn="$INTERFACE_DETECT_NUM" \
	'BEGIN {printf "%4d %4d  %s  %s  ", tc, tfc, std, etd;
			if(pp) printf "PCIe:OK   Detect %d  ", pdn
			else printf "PCIe:Fail Detect %d  ", pdn
			if(ip) printf "INTERFACE:OK\n"
			else printf "INTERFACE:Fail, Detect %d\n", idn}' >> $FILENAME


END_TIME=`date`
END_TIME_sec=`date +%s`

#let RUN_TIME=$END_TIME_sec-$START_TIME_sec
RUN_TIME=`expr $END_TIME_sec - $START_TIME_sec`


if [ $RUN_TIME -gt $SECONDS_OF_DAY ]; then
	DAYS=`expr $RUN_TIME / $SECONDS_OF_DAY`
else
	DAYS=0
fi

if [ $RUN_TIME -gt $SECONDS_OF_HOUR ]; then
	HOURS=`expr $RUN_TIME % $SECONDS_OF_DAY`
	HOURS=`expr $HOURS / $SECONDS_OF_HOUR`
else
	HOURS=0
fi

if [ $RUN_TIME -gt $SECONDS_OF_MINUTE ]; then
	MINUTES=`expr $RUN_TIME % $SECONDS_OF_HOUR`
	MINUTES=`expr $MINUTES / $SECONDS_OF_MINUTE`
else
	MINUTES=0
fi

SECONDS=`expr $RUN_TIME % $SECONDS_OF_MINUTE`

echo "START_TIME : $START_TIME"
echo "  END_TIME : $END_TIME"
awk -v d="$DAYS" -v h="$HOURS" -v m="$MINUTES" -v sec="$SECONDS" \
		'BEGIN {printf "  RUN_TIME : ";
                if(d)      printf "%dday %dhour %dmin %2dsec\n", d, h, m, sec;
				else if(h) printf "%dhour %dmin %dsec\n", h, m, sec;
				else if(m) printf "%dmin %dsec\n", m, sec;
				else       printf "%d seconds\n", sec}'

poweroff

export SCRIPT_PROGESS=0


