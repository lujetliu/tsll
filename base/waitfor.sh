#!/bin/bash

# 等待指定用户登录

# 设置默认值

mailpot=FALSE
interval=60

while getopts mt: option
do
	case $option
		in 
		m) mailpot=TRUE;;
		t) interval=$OPTARG;;
		\?) echo "Usage: waitfor [-m] [-t n] user"
			echo "-m means to be informed by mail"
			echo "-t means check every n secs."
			exit 1;;
	esac
done


# 确保指定了用户名

if [ "$OPTIND" -gt "$#" ]
then
	echo "Missing user name!"
	exit 2
fi

shiftcount=$((OPTIND-1))
shift $shiftcount
user=$1

# 检查用户是否登录

until who | grep "^$user " > /dev/null
do
	sleep $interval
done

# 执行到此处, 用户已经登录
if [ "$mailpot" = FALSE ]
then
	echo "$user has logged on"
else
	runner=$((whoami | cut -c-8))
	echo "$user has loggen on" | mail $runner
fi

