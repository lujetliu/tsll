#!/bin/bash

# 功能描述(Description): 服务状态监控

if [ -z $1 ]; then 
	echo "错误: 未输入服务名称."
	echo "用法: 脚本名 服务器名称."
	exit
fi

if systemctl is-active $1  &>/dev/null; then
	echo "$1 已经启动..."
else
	echo "$1 未启动..."
fi

if systemctl is-enabled $1 &> /dev/null; then 
	echo "$1 是开机自启动项"
else
	echo "$1 不是开机自启动项"
fi

