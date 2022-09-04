#!/bin/bash

# 功能描述: 判断某台主机是否可以 ping 通
# ping 通脚本返回up, 否则返回down

if [ -z "$1" ]; then 
	echo -n "用法: 脚本"
	echo -e "\033[32m域名或IP\033[0m"
	exit
fi

<<DESC
 -c 设置ping的次数
 -i 设置ping间隔描述 
    ping: cannot flood; minimal interval allowed for user is 200ms
 -W 设置超时时间
 TODO: ping  wwwisdf
 64 bytes from Inspiron (127.0.0.2): icmp_seq=1 ttl=64 time=0.070 ms ???
DESC

ping -c2 -i1 -W2 "$1" &>/dev/null
if [ $? -eq 0 ]; then 
	echo "$1 is up"
else
	echo "$1 is down"
fi
