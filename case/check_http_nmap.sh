#!/bin/bash

# 功能描述: 使用nmap的端口扫描功能监控http端口
# TODO: 添加发送邮件功能

ip=127.0.0.1

<<DESC
 -n 禁止DNS反向解析
-sT 执行针对TCP的端口扫描
 -sS 执行针对TCP的半开扫描
 -p 指定需要扫描的特定端口号
DESC

# 判断是否以管理员身份执行脚本, 以root用户登录的UID为0
if [ $UID -ne 0 ]; then 
	$setcolor_failure
	echo "请以管理员身份运行该脚本."
	$setcolor_normal
	exit
fi


nmap -n -sS -p80 $ip | grep -q "^80/tcp open"
if [ $? -eq 0 ]; then
	echo "http service is running on $ip"
else
	echo "http service is stoped on $ip"
fi
