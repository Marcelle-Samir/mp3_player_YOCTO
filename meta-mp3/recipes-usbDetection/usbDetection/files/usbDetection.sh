#!/bin/sh

chmod 777 /mp3overlay/songsList.txt

while true; do

	ls /dev > /mp3overlay/dev_test.txt
	dev_grep=`grep -c "sdb1" /mp3overlay/dev_test.txt`
	if [[ $dev_grep -eq 0 ]]
	then
		 dev_grep=`grep -c "sda1" /mp3overlay/dev_test.txt`
	fi

	df > /mp3overlay/df_test.txt
	df_grep=`grep -c "sdb1" /mp3overlay/df_test.txt`

	if [[ $df_grep -eq 0 ]]
	then
		 df_grep=`grep -c "sda1" /mp3overlay/df_test.txt`
	fi


	if [[ $df_grep -eq 0  && $dev_grep -ne 0 ]]
	then
    		sleep 3
		partitions=$(fdisk -l /dev/sd* | grep -v 'Unknown' | grep -v 'Empty' | awk '/^\/dev\/sd/ {print $1}')
		
		for partition in $partitions; do
			mountpoint="/media/$(basename $partition)"
			mkdir -p $mountpoint
			mount $partition $mountpoint

			espeak -g15 -s130 -ven-us+f1 "storage device is added" --stdout | aplay
		done
		find $mountpoint -name "*.mp3" | wc -l > /mp3overlay/usb_songs_num.txt

		find /mp3overlay/Songs_list_source -name "*.mp3" > /mp3overlay/songsList.txt
		find $mountpoint -name "*.mp3" >> /mp3overlay/songsList.txt

	elif [[ $df_grep -ne 0  && $dev_grep -eq 0 ]]
	then
		espeak -g15 -s130 -ven-us+f1 "storage device is removed" --stdout | aplay
		umount $mountpoint
	fi
done
