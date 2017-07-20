#!/bin/bash
# 树莓派新机初始化程序

echo "树莓派初始化程序"
echo "Loading..."
testpoint='[ $? != 0 ] && echo -e "!\c" || echo -e ".\c"'

# 修改用户密码
echo -e "修改用户密码? (y/n) \c"
read -n 1
echo " "
case $REPLY in
[y,Y])
	sudo passwd pi
;;
esac
# 修改主机名称
echo -e "修改主机名称？(y/n) \c"
read -n 1
echo " "
case $REPLY in
[y,Y])
	sudo chmod 777 /etc/hostname
	read
	sudo echo "$REPLY" > /etc/hostname
	sudo chmod 644 /etc/hostname
	echo "...Success"
;;
esac

# 修改软件源
echo -e "修改软件源? (y/n) \c"
read -n 1
case $REPLY in
[y,Y])
	mysources="/etc/apt/sources.list"
	sudo chmod -Rf 777 $mysources
	[ $? != 0 ] && echo -e "!\c" || echo -e ".\c"
	sudo echo '#deb http://mirrordirector.raspbian.org/raspbian/ jessie main contrib non-free rpi' > $mysources
	[ $? != 0 ] && echo -e "!\c" || echo -e ".\c"
	sudo echo "# Uncomment line below then \'apt-get update\' to enable \'apt-get source\'" >>  $mysources 
	[ $? != 0 ] && echo -e "!\c" || echo -e ".\c"
	sudo echo "#deb-src http://archive.raspbian.org/raspbian/ jessie main contrib non-free rpi" >>  $mysources
	[ $? != 0 ] && echo -e "!\c" || echo -e ".\c"
	sudo echo "deb http://mirrors.tuna.tsinghua.edu.cn/raspbian/raspbian/ jessie main non-free contrib" >>  $mysources
	[ $? != 0 ] && echo -e "!\c" || echo -e ".\c"
	sudo echo "deb-src http://mirrors.tuna.tsinghua.edu.cn/raspbian/raspbian/ jessie main non-free contrib" >>  $mysources
	[ $? != 0 ] && echo -e "!\c" || echo -e ".\c"
	sudo chmod -Rf 644 $mysources
	[ $? != 0 ] && echo -e "!\c" || echo -e ".\c"
	echo -e "Success\c"
;;
esac
echo " "

# 更新系统
read -p '更新系统？ （y/n）: ' -n 1
echo ' '
case $REPLY in
[y,Y])
	echo -e "    正在检测网络\c"
	ping -c 1 mirrors.tuna.tsinghua.edu.cn &> /dev/null
	[ $? != 0 ] && echo -e "!\c" || echo -e ".\c"
	ping -c 1 mirrors.tuna.tsinghua.edu.cn &> /dev/null
	[ $? != 0 ] && echo -e "!\c" || echo -e ".\c"
	ping -c 1 mirrors.tuna.tsinghua.edu.cn &> /dev/null
	[ $? != 0 ] && echo -e "!\c" || echo -e ".\c"
	ping -c 1 mirrors.tuna.tsinghua.edu.cn &> /dev/null
	[ $? != 0 ] && echo -e "!\c" || echo -e ".\c"
	if [ $? != 0 ]
	then
		echo "Wrong network!"
	else
		echo "Success"
		sleep 0.5s
		echo -e "    更新：清空......\c"
		sudo apt-get clean &> /dev/null
		[ $? != 0 ] && echo "Wrong" || echo  "Success"
		echo "    更新：列表"
		sudo apt-get update
		echo "    更新：程序"
		sudo apt-get upgrade -y
		echo "    更新：系统"
		sudo apt-get dist-upgrade
		echo "    更新：固件"
		sudo apt-get rpi-update
	fi
;;
*)
	echo "    取消更新"
;;
esac

# 安装常用软件
read -p '安装常用软件？ （y/n）: ' -n 1
echo ' '
case $REPLY in
[y,Y])
	sudo apt-get install -y git vim build-essential cifs rpi-update xrdp
;;
*)
	echo "取消安装"
;;
esac

# 开机挂载Samba(Pi)
# 本段考虑去掉，可以以后每次用Samba的时候执行单次挂载脚本
read -p '开机自动挂载Samba(pi)？(y/n) ' -n 1
case $REPLY in
[y,Y])
	echo -e "\n    正在添加\c"
	ping -c 1 192.168.199.228 &> /dev/null
	ping -c 1 192.168.199.228 &> /dev/null
	ping -c 1 192.168.199.228 &> /dev/null
	ping -c 1 192.168.199.228 &> /dev/null
	if [ $? != 0 ]
	then
		echo "网络连接失败！"
	else
		sudo cat /etc/fstab | grep 199.228 &> /dev/null
		if [ $? != 0 ]
		then
			sudo chmod 0777 /etc/fstab
			echo "//192.168.199.228/pi	/mnt/pi	cifs	credentials=/root/auth.smb	0	0" >> /etc/fstab
			sudo chmod 0644 /etc/fstab
			DIR="/home/auth.smb"
			sudo touch $DIR
			sudo chmod 0777 $DIR
			echo "username=pi" > $DIR
			echo "password=yours521" >> $DIR
			echo "domain=WORKGROUP" >> $DIR
			sudo chmod -Rf 0600 $DIR
			sudo mv $DIR /root/
			echo "Success"
		else
			echo "设置已经存在"
		fi
	fi
;;
*)
	echo "...取消添加"
;;
esac
