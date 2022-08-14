#!/bin/bash

user="$1"

if who | grep "^$user " > /dev/null
then
	echo "$user is logged on"
else
	echo "$user is not logged on"
fi
