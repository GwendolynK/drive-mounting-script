#!/bin/bash
#
# https://github.com/WestleyK/drive-mounting-script
# Created by: Westley K
# Date: Jun 22, 2018
# version-5.0
# Designed and tested on raspberry pi
#

# 8 diffrent drives maxinum, NOT RECOMMENDED FOR MORE THEN ONE DRIVE!
# this version will not unmount drives when mounting, DO NOT MOUNT NORE THAN ONE DRIVE!

# the mount point, feel free to change it :)
mount_point=$"/media/pi"


option=$1
if [[ -n $option ]]; then 
	case $option in
		-h | -help)
			echo "usage: ./mounter-driver-v5.0.sh [-option(s)]
		-h | -help | --help (display help menu)
		-a | -all (unmount all drives)
		-d (display all drives, mounted or not)
		-m (mount drive only if there one)
		-r (remount the drive, this only works if one drive is connected)"
			exit
			;;
		-a | -all)
			un_mount_all=$"true"
			;;
		-d)
			display_drive=$"true"
			;;
		-m)
			mount_drive=$"true"
			;;
		-r)
			echo "remounting drive..."
			re_mount=$"true"
			;;
		*)
			echo "option not found, try: ./mounter-driver-v5.0.sh -help"
			exit
			;;
	esac
fi


if [[ $un_mount_all == "true" ]]; then
	disk_loca=$( df -aTh | grep '^/dev/s' | cut -f 1 -d ' ' )
	if [[ -z $disk_loca ]]; then
		echo "no disk(s) to un-mount :o"
		exit
	fi
	while [[ -n $disk_loca ]]; do	
		sudo umount $disk_loca &> /dev/null
		echo "un-mounted: $disk_loca"
		disk_loca=$( df -aTh | grep '^/dev/s' | cut -f 1 -d ' ' )
	done
	echo "done"
	exit
fi



if [[ $display_drive == "true" ]]; then 
	what_to_mount=$( sudo fdisk -l | grep '^/dev/s' )
	if [[ -n $what_to_mount ]]; then
		sudo fdisk -l | grep '^/dev/s'
		exit
	else
		echo "there's no drives! :o"
		exit
	fi
fi


if [[ $mount_drive == "true" ]]; then
	drive_check=$( sudo fdisk -l | grep '^/dev/s' | cut -f 1 -d ' ' | wc -l )
	if [[ $drive_check -eq "2" ]]; then
		echo "theres more than one drive! nice try :P"
		exit
	fi
	disk_loca=$( sudo fdisk -l | grep '^/dev/s' | cut -f 1 -d ' ' )
	sudo mount $disk_loca $mount_point -o uid=pi,gid=pi
	echo "mounted to: /media/pi"
	exit
fi



echo
echo
# check if theres anything to mount or unmount
sudo fdisk -l | grep '^/dev/s' | grep -n 'dev/s'
whats_to_mount=$( sudo fdisk -l | grep '^/dev/s' | grep -n 'dev/s' )
if [[ -z $whats_to_mount ]]; then
	echo "there is nothing you can mount or un-mount"
	echo
	exit
fi



echo
read -p "what would you like to mount or un-mount? [1-8]" -n 1 -r
# 8 maxinum diffrent drives
echo
sleep 0.25s
if [[ $REPLY != [1-8] ]]; then
	echo
	echo "???"
	echo
	exit
fi
# get the location of the disk
disk_loca=$( sudo fdisk -l | grep '^/dev/s' | grep -n '/dev/s' | grep ^$REPLY | cut -f 1 -d ' ' | cut -c3- )
if [[ -z $disk_loca ]]; then 
	echo
	echo "WRONG MOVE!"
	echo
	exit
fi
echo 
echo $disk_loca
echo
read -p "(m)mount, (u)un-mount or (r)remount?  [m,u,r]" -n 1 -r
echo
case $REPLY in
	m)
		echo "mounting..."
		sleep 0.2s
		sudo mount $disk_loca $mount_point -o uid=pi,gid=pi
		echo "mounted to: media/pi"
		exit
		;;
	M)
		echo "mounting..."
		sleep 0.2s
		sudo mount $disk_loca $mount_point -o uid=pi,gid=pi
		echo "mounted to: media/pi"
		;;
	u)
		echo -n "un-mounting..."
		sleep 0.2s
		sudo umount $disk_loca
		echo "un-mounted"
		echo "done"
		exit
		;;
	U)
		echo -n "un-mounting..."
		sleep 0.2s
		sudo umount $disk_loca
		echo "un-mounted"
		echo "done"
		exit
		;;
	r)
		echo "remounting..."
		sudo umount $disk_loca
		echo -n "unmounted, "
		sleep 0.2s
		echo -n "mounting..."
		sudo mount $disk_loca $mount_point -o uid=pi,gid=pi
		echo "done"
		exit
		;;
	R)
		echo "remounting..."
		sudo umount $disk_loca
		echo -n "unmounted, "
		sleep 0.2s
		echo -n "mounting..."
		sudo mount $disk_loca $mount_point -o uid=pi,gid=pi
		echo "mounted to: /media/pi"
		echo "done"
		exit
		;;
esac


#
# End Scripr
#
