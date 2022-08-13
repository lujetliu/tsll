#!/bin/bash

# 标出指定文件中每一行的行号, 如果文件没有作为参数给出, 则使用标准输入

lineno=1

cat $* |  # 使用管道将文件传给 while, 如果没有文件, 则read从标准输入读取
	while read -r line # 使用 -r 避免shell解释读入的行里的反斜线
	do
		echo "$lineno: $line"
		lineno=$((lineno+1))
	done
