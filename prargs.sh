#!/bin/bash
# 打印输出命令行参数, 一行一个

while [ "$#" -ne 0 ]
do
	echo "$1"
	shift
done

