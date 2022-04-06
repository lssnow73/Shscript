#!/bin/bash

echo -n "Power ON/OFF TEST Start..."

if [ $SCRIPT_PROGESS ]; then
	if [ $SCRIPT_PROGESS == 1 ]; then
		exit 0
	fi
fi

export SCRIPT_PROGESS=1

PCIe_NUM=44
INTERFACE=ens33
FILENAME="stats_save_file.txt"
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

RX_PRE_CNT=`ifconfig $INTERFACE | awk '{ if(NR == 5) print $3 }'`
TX_PRE_CNT=`ifconfig $INTERFACE | awk '{ if(NR == 7) print $3 }'`

$MACRO_SLEEP $TRAFFIC_CHECK_SLEEP

RX_CNT=`ifconfig $INTERFACE | awk '{ if(NR == 5) print $3 }'`
TX_CNT=`ifconfig $INTERFACE | awk '{ if(NR == 7) print $3 }'`

#let "RX_DIFF=$RX_CNT-$RX_PRE_CNT"
#let "TX_DIFF=$TX_CNT-$TX_PRE_CNT"
RX_DIFF=`expr $RX_CNT - $RX_PRE_CNT`
TX_DIFF=`expr $TX_CNT - $TX_PRE_CNT`

if [[ $RX_DIFF > 0 && $TX_DIFF > 0 ]]; then
	TRAFFIC_Pass=1
else
	TRAFFIC_Pass=0
fi

if [[ $PCIe_Pass == 0 || $TRAFFIC_Pass == 0 ]]; then
	TEST_FAIL_CNT=`expr $TEST_FAIL_CNT + 1`
fi

END_TEST_DATE=`date +%F_%T`

awk -v tc="$TEST_CNT" -v tfc="$TEST_FAIL_CNT" -v std="$START_TEST_DATE" -v etd="$END_TEST_DATE" \
    -v pp="$PCIe_Pass" -v tp="$TRAFFIC_Pass" -v pdn="$PCIe_DETECT_NUM" \
	-v rxd="$RX_DIFF" -v txd="$TX_DIFF" \
	'BEGIN {printf "%4d %4d  %s  %s  ", tc, tfc, std, etd;
			if(pp) printf "PCIe:OK   Detect %d  ", pdn
			else printf "PCIe:Fail Detect %d  ", pdn
			if(tp) printf "TRAFFIC:OK\n"
			else printf "TRAFFIC:Fail, RX %d, TX %d\n", rxd, txd}' >> $FILENAME


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

export SCRIPT_PROGESS=0


