#!/bin/bash

# 功能描述: 一键源码安装Nginx

# 定义不同的颜色属性
setcolor_failure="echo -en \\033[91m"
setcolor_success="echo -en \\033[32m"
setcolor_normal="echo -e \\033[0m"

# 判断是否以管理员身份执行脚本
if [ $UID -ne 0 ]; then 
	$setcolor_failure
	echo -n "请以管理员身份运行该脚本"
	$setcolor_normal
	exit
fi

# 判断系统中是否存在wget下载工具
# wget使用-c选项可以开启断点续传功能
if which wget &>/dev/null ; then
	echo "wget installed"
	# TODO:
fi
