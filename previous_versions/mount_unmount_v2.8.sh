#!/bin/bash

echo 
sudo fdisk -l | grep '^/dev/s' | cut -f 1,8,9,10,11,12,13,14,15,16,18 -d ' ' | grep -n 'dev/s'
notest=$( sudo fdisk -l | grep '^/dev/s' | cut -f 1,8,9,10,11,12,13,14,15,16,18 -d ' ' | grep -n 'dev/s' )
if [[ -z $notest ]]; then
	echo "there is nothing you can mount or un-mount"
	echo
	exit
fi
echo
echo "what would you like to mount or un-mount?"
read input
if [[ $input != [1-8] ]]; then
	echo
	echo "???"
	echo
	exit
fi
varloc=$( sudo fdisk -l | grep '^/dev/s' | grep -n '/dev/s' | grep ^$input | cut -f 1 -d ' ' | cut -c3- )
if [[ -z $varloc ]]; then 
	echo
	echo "WRONG MOVE!"
	echo
	exit
fi
echo 
echo $varloc
echo 
echo "mount or un-mount?"
echo "[m,u]"
read input2
if [[ $input2 == "m" || $input2 == "M" ]]; then
	echo "mounting..."
	sleep 1.5s
	sudo mount $varloc /media/pi -o uid=pi,gid=pi
	echo "mounted to /media/pi"
else
	if [[ $input2 == "u" || $input == "U" ]]; then
		echo "unmounting..."
		sleep 1.5s
		sudo umount $varloc
		echo "unmounted"
	else
		echo
		echo "err"
		echo "wrong input!"
		echo
		exit
	fi
fi

