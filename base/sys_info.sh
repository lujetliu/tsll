#!/bin/bash

# 本脚本获取系统各项性能指标, 并根据预设阈值决定是否给管理员发送邮件进行报警

# 变量定义列表
# time:时间
# loalip:wlo1 网卡ip
# free_mem:剩余内存大小
# free_disk: 剩余磁盘大小
# cpu_load: 15min平均负载
# login_user: 登录系统的用户
# procs: 当前进程数量

local_time=$(date +"%Y%m%d %H:%M:%S")
local_ip=$(ifconfig wlo1 | grep netmask | tr -s " " | cut -d " " -f3)  
# tr -s " " 缩减连续重复的字符成指定的单个字符
free_mem=$(cat /proc/meminfo | grep Avai | tr -s " "  | cut -d " " -f2)
free_disk=$(df | grep "/$" | tr -s " " | cut -d  ' ' -f4)
cpu_load=$(cat /proc/loadavg | cut -d ' ' -f3)
login_user=$(who | wc -l )
procs=$(ps aux | wc -l)


# vmstat 是一个标准的工具, 会报告 Linux 系统的虚拟内存统计;  TODO: 熟练使用
# vmstat 会报告有关进程、内存、分页、块 IO、陷阱（中断）和 cpu 活动的信息;
# vmstat 命令可以查看系统中cpu的中断数, 上下文切换数量
# CPU 处于I/O等待的时间, 用户态及系统态消耗的CPU的统计数据
# vmstat 命令输出的前2行信息是头部信息, 第3行信息是为开机到当前的平均数据
# 第4行开始的数据是每秒钟的实时数据
# irq: 中断
# cs: 上下文切换
# usertime: 用户态
# CPU, systime: 系统态CPU
# iowait: 等待I/O时间
irq=$(vmstat 1 2 | tail -n +4 | tr -s ' ' | cut -d ' ' -f12)
cs=$(vmstat 1 2 | tail -n +4 | tr -s ' ' | cut -d ' ' -f13)
usertime=$(vmstat 1 2 | tail -n +4 | tr -s ' ' | cut -d ' ' -f14)
systime=$(vmstat 1 2 | tail -n +4 | tr -s ' ' | cut -d ' ' -f15)
cs=$(vmstat 1 2 | tail -n +4 | tr -s ' ' | cut -d ' ' -f13)
iowait=$(vmstat 1 2 | tail -n +4 | tr -s ' ' | cut -d ' ' -f17)



