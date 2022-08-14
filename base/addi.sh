#!/bin/bash

# 将标准输入中的一对整数相加

while read n1 n2
do
	echo $(( $n1+$n2 ))
done
