#!/bin/bash 
#自动挂载(临时)、卸载网络samba文件
echo '正在检测网络通畅性'
ping -c 4 192.168.199.99 &> /dev/null
if [ $? != 0 ]
then
	echo '网络连接失败！挂载终止！'
else
	echo '网络通畅'
	sleep 0.5s
	echo '开始挂载'
	mount //192.168.199.99/dsm-downfile /mnt/DSM  -o user=admin,passwd=redhat521
	if [ $? = 0 ]
	then
		echo '挂载成功'
		sleep 0.2
		echo '挂载路径：/mnt/DSM'
	else
		echo '挂载失败'
	fi
fi
