#!/bin/bash

# 设置并导出与数据库相关的变量

HOME=/home/lucas/gogo/tsll/data
BIN=$HOME/bin
DATA==$HOME/rawdata
PATH=$PATH:$BIN
CDPATH=:$HOME:$DATA

PS1="DB: "
export HOME BIN DATA PATH CDPATH PS1


# 启动一个新shell
exec /bin/sh
