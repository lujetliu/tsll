#!/bin/bash

# 功能描述: 脚本配置的vnc服务器, 客户端无须验证密码即可连接
# 客户端仅有查看远程桌面的权限, 没有鼠标和键盘的操作权限

rpm --quiet -q tigervnc-server
