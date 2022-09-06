#!/bin/bash
# 功能描述: 使用cURL 访问具体的HTTP页面, 检测http状态码
# TODO: 发送邮件功能

<<COMMENT
 -m 设置超时时间
 -s 设置静默连接
 -o 下载数据另存为	
 -w 返回附加信息, HTTP状态码

 通过%{有效名称}的方式可以自定义需要输出的附加内容
 cURL常用的有效名称:
 http_code: HTTP状态码
 local_ip: 本地ip地址
 local_port: 本地端口号
 redirect_url: 重定向的真实URL
 remote_ip: 远程id地址
 remote_port: 远程端口号
 size_download: 下载数据的总字节数
 speed_download: 平均每秒下载速度
 time_total: 完成一次连接请求的总时间
COMMENT

url=http://182.150.116.28:9066/v1/testapi
date=$(date +"%Y-%m-%d %H:%M:%S")
status_code=$(curl -m 3 -s -o /dev/null -w %{http_code} $url) 
mail_to="root@localhost"
mail_subject="http_warning"

if [ $status_code -ne 200 ]; then
	mail -s $mail_subject $mail_to <<- EOF
	检测时间: $date
	$url 页面异常, 服务器返回状态码: ${status_code}
	请尽快排查异常
	EOF
else
	cat >> /var/log/http_check.log <<- EOF
	$date "$url 页面访问正常"
	EOF
fi


