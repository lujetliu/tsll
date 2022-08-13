#!/bin/bash
# 给参数指定的字符分类

if [ $# -ne 1 ]
then
	echo Uasge: ctype char
	exit 1
fi

# 确保只输入一个字符
char="$1"
numchars=$(echo "$char" | wc -l)

if [ "$numchars" -eq 1 ]
then
	:  # 空命令, 什么都不做,  shell要求then之后必须有命令
else
		echo Please type a single character
		exit 1
fi

# 进行分类
case  "$char"
in 
	[0-9]) echo digit;;
	[a-z]) echo lowercase letter;;
	[A-Z]) echo uppercase letter;;
	*) echo special character;;
esac

