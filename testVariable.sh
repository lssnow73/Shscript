#!/bin/bash

count=0

echo "Start value: $count"

while [ $count -lt 3 ]; do

	let "count++"
	echo "count is $count"
done

