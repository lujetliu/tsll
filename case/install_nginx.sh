#!/bin/bash

# 功能描述: 一键源码安装Nginx

# 定义不同的颜色属性
setcolor_failure="echo -en \\033[91m"
setcolor_success="echo -en \\033[32m"
setcolor_normal="echo -e \\033[0m"

# 判断是否以管理员身份执行脚本, 以root用户登录的UID为0
if [ $UID -ne 0 ]; then 
	$setcolor_failure
	echo -n "请以管理员身份运行该脚本."
	$setcolor_normal
	exit
fi

while read -p "确定安装nginx?[Y/N]" is_install # 使用 -r 避免shell解释读入的行里的反斜线
do
	if [[ "$is_install" == [Yy] ]]; then
		break
	elif [[ "$is_install" == [Nn] ]]; then
		exit
	else
		continue
	fi
done

# 判断系统中是否存在wget下载工具
# wget使用-c选项可以开启断点续传功能
if which wget &>/dev/null ; then
	echo "wget installed"
	wget -c https://nginx.org/download/nginx-1.23.1.tar.gz
else
	$setcolor_failure 
	echo -n "未找到wget, 请先安装该软件."
	$setcolor_normal
	exit
fi

# 如果没有nginx账户, 则创建账户
# 使用 id 命令判断是否存在nginx账户, TODO: 熟悉id命令
if ! id nginx &>/dev/null ; then
	adduser -s /sbin/nologin nginx  # TODO: 创建账户
fi

<<DESC
	测试是否存在正确的源码包软件
	在源码编译安装前, 先安装相关依赖包
	gcc: C语言编译器, pcre-devel: Perl 兼容的正则表达式库
	zlib-devel: gzip 压缩库, openssl-devel: Openssl 加密库
DESC
if [ ! -f nginx-1.23.1.tar.gz ]; then
	$setcolor_failure
	echo -n "未找到nginx源码包, 请先正确下载该软件..."
	$setcolor_normal
	exit
else
	apt install -y gcc pcre-devel zlib-devel openssl-devel
	clear
	$setcolor_success
	echo -n "需要花几分钟时间编译安装nginx..."
	$setcolor_normal
	sleep 6
	tar -xf nginx-1.23.1.tar.gz
	# 编译源码安装nginx, 指定账户和组, 指定安装路径, 开启需要的模块, 
	# 禁用不需要的模块
	cd nginx-1.23.1
	./configure \ 
		--user=nginx \ 
		--group=nginx \
		--prefix=/data/server/nginx \
		--with-stream \
		--with-http_ssl_module \
		--with-http_stub_status_module \
		--without-http_autoindex_module \
		--without-http_ssi_module 
	
	make
	make install
fi

if [ -x /data/server/nginx/sbin/nginx ]; then
	clear
	$setcolor_success
	echo -n "一键部署nginx已经完成!"
	$setcolor_normal
fi

