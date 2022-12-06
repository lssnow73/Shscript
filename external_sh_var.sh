#!/bin/bash

echo "External Shell Variable Test"

if [ $ABCDEF ]; then
	echo "ABCDEF is defined, Value $ABCDEF"
else
	echo "ABCDEF is not defined"
fi

export ABCDEF=1
echo "Set export ABCDEF"

if [ $ABCDEF ]; then
	echo "ABCDEF is defined, Value $ABCDEF"
else
	echo "ABCDEF is not defined"
fi

