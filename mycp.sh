#!/bin/bash

# 复制文件
numargs=$#
filelist=
copylist=
option=


# 处理参数, 将最后一个参数之外的其他参数保存在变量filelist中
while [ "$#" -gt 1 ] ; do
	filelist="$filelist $1"
	shift
done

to="$1"

# 如果少于两个参数或者多于两个参数且最后一个参数不是目录, 则发出错误信息
if [ "$numargs"  -lt 2 -o "$numargs" -gt 2 -a ! -d "$to" ] ; then
	echo "Usage: mycp file1 file2"
	echo "		 mycp file(s) dir"
	exit 1
fi


# 遍历filelist中的每个文件
for from in $filelist ; do
	# 查看目标文件是否为目录
	if [ -d "$to" ] ; then
		tofile="$to/$(basename $from)"
	else 
		tofile="$to"
	fi

	# 如果from是目录, 更新option
	if [ -d "$from" ] ; then
		option="-r"
	fi

	# 如果文件不存在, 或者文件存在用户要求进行覆盖, 则将其添加到变量copylist
	if [ -e "$tofile" ] ; then
		echo "$tofile already exists; overwrite(yes/no)"
		read answer
		
		if [ "$answer" = yes ] ; then
			copylist="$copylist $from"
		fi
	else
		copylist="$copylist $from"
	fi
done


# 开始复制操作, 首先确保提供了待复制的文件
if [ -n "$copylist" ] ; then
	cp $option $copylist $to # 复制
fi
