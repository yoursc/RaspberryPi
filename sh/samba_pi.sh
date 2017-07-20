#!/bin/bash 
#自动挂载(临时)、卸载网络samba文件
DIR="/mnt/HDD"
IPAD="192.168.199.98"
SMB="smb"
USER="autorun"
PASSWD='107107107'
echo '挂载：Samba（pi）'
if [ -d $DIR/ ]
then
	echo '设备已挂载'
	sleep 0.5s
	read -p '是否卸载：Samba(pi)? (y/n) : '  -n 1
	echo ''
	case $REPLY in
	[y,Y])
		echo '正在卸载'
		sudo umount //$IPAD/$SMB
		[ $? = 0 ] && echo '卸载成功' || echo '卸载失败'
	;;
	*)
		echo '取消卸载'
	;;
	esac
else
	sleep 0.5s
	echo '正在检测网络通畅性'
	ping -c 4 $IPAD &> /dev/null
	if [ $? != 0 ]
	then
		echo '网络连接失败！挂载终止！'
	else
		echo '网络通畅'
		sleep 0.5s
		echo '开始挂载'
		[ ! -e $DIR ] && sudo mkdir -p $DIR
		sudo mount //$IPAD/$SMB $DIR  -o user=$USER,passwd=$PASSWD
		if [ $? = 0 ]
		then
			echo '挂载成功'
			sleep 0.2
			echo "挂载路径：$DIR"
		else
			echo '挂载失败'
		fi
	fi
fi