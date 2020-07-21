#!/bin/sh

# set the buttons pin as input pins
##################################################
# Start button
echo "26" >> /sys/class/gpio/export
echo "in" >> /sys/class/gpio/gpio26/direction
# pause / play button
echo "16" >> /sys/class/gpio/export
echo "in" >> /sys/class/gpio/gpio16/direction
# next song button
echo "5" >> /sys/class/gpio/export
echo "in" >> /sys/class/gpio/gpio5/direction
# previous song button
echo "6" >> /sys/class/gpio/export
echo "in" >> /sys/class/gpio/gpio6/direction
##################################################

# echo the songs names exist in the Songs_list_source directory to form the songs_list  
find /mp3overlay/Songs_list_source -name "*.mp3" > /mp3overlay/songsList.txt

chmod 777 /mp3overlay/songsList.txt

echo "0" > /mp3overlay/play_pause_button.txt
echo "0" > /mp3overlay/next_button.txt
echo "0" > /mp3overlay/prev_button.txt
echo "0" > /mp3overlay/shuffle_button.txt

chmod 777 /mp3overlay/play_pause_button.txt
chmod 777 /mp3overlay/next_button.txt
chmod 777 /mp3overlay/prev_button.txt
chmod 777 /mp3overlay/shuffle_button.txt

# set an initial value to pause_play_flag so if the 
pause_play_flag=2
# get the total nsumber of songs exist in the songsList.txt  
total_songs_num=`cat /mp3overlay/songsList.txt | wc -l`
# set an initial value to song_cont
song_count=0
echo "nothing played" > /mp3overlay/song_status.txt
while :
do
	total_songs_num=`cat /mp3overlay/songsList.txt | wc -l`
	# getting the readings from the keyboard
	play_pause_button=`sed -n "1{p;q}" /mp3overlay/play_pause_button.txt`
	next_button=`sed -n "1{p;q}" /mp3overlay/next_button.txt`
	prev_button=`sed -n "1{p;q}" /mp3overlay/prev_button.txt`
	shuffle_button=`sed -n "1{p;q}" /mp3overlay/shuffle_button.txt`

	# play/pause button is pressed case 
	if [[ $(cat /sys/class/gpio/gpio26/value) -eq 1 ]] ||  [[ "$play_pause_button" -eq 1 ]]
	then
		if [[ $pause_play_flag -eq 0 ]]
		then		
			# stop the running song  
			killall -STOP play
			# set the pause_play_flag, because now there's a stopped song 
			pause_play_flag=1
			# this only for displaying songs name
			next_song=`sed -n "$song_count{p;q}" /mp3overlay/songsList.txt`
			echo "MP3 Paused > $next_song" > /mp3overlay/song_status.txt

		elif [[ $pause_play_flag -eq 1 ]]		
		then	
			# return the stoped song to the background	
			killall -CONT play
			# clear the pause_play_flag, because the isn't stopped songs anymore
			pause_play_flag=0
			# this only for displaying songs name	
			next_song=`sed -n "$song_count{p;q}" /mp3overlay/songsList.txt`
			echo "MP3 Playing > $next_song" > /mp3overlay/song_status.txt

		elif [[ $pause_play_flag -eq 2 ]]		
		then
			# end any running process 
			killall -15 play
			# set the song_count to the initial value to play the first song in the songsList.txt
			song_count=1
			# pick the song name from the list to be played according to the song_count value
			next_song=`sed -n "$song_count{p;q}" /mp3overlay/songsList.txt`
			# run the song in the background 
			lame --quiet --decode /$next_song - | play -q - &
			# make sure that the pause_play_flag is cleared
			pause_play_flag=0
			# this only for displaying songs name	
			echo "MP3 Playing > $next_song" > /mp3overlay/song_status.txt

		fi
		echo "0" > /mp3overlay/play_pause_button.txt
		# to avoid button debouncing 
		sleep 0.5		
	fi

	# next song button is pressed
	if [[ $(cat /sys/class/gpio/gpio5/value) -eq 1 ]] || [[ "$next_button" -eq 1 ]]
	then
		# end any running process 
		killall -15 play
		if [[ $song_count -lt $total_songs_num ]]
		then
			# incrementing the song_count to select the next song in songsList.txt
			song_count=$((song_count+1))
			# pick the song name from the list to be played according to the song_count value
			next_song=`sed -n "$song_count{p;q}" /mp3overlay/songsList.txt`	
			# this only for debugging 
			echo "nextsongIf= $next_song" >> /mp3overlay/debug.txt
			echo "nextcountIf= $song_count" >> /mp3overlay/debug.txt	
		else
			# reset the song_count to start the list from the first song  
			song_count=1
			# pick the song name from the list to be played according to the song_count value
			next_song=`sed -n "$song_count{p;q}" /mp3overlay/songsList.txt`	
			# this only for debugging 
			echo "nextsongElse= $next_song" >> /mp3overlay/debug.txt
			echo "nextcountElse= $song_count" >> /mp3overlay/debug.txt	
		fi		
		# run the song in the background
		lame --quiet --decode /$next_song - | play -q - &
		# make sure that the pause_play_flag is cleared
		pause_play_flag=0
		echo "0" > /mp3overlay/next_button.txt
		# this only for displaying songs name	
		echo "MP3 Playing > $next_song" > /mp3overlay/song_status.txt
		# to avoid button debouncing 
		sleep 0.5
	fi

	# previous song button is pressed
	if [[ $(cat /sys/class/gpio/gpio6/value) -eq 1 ]] || [[ "$prev_button" -eq 1 ]]
	then
		# end any running process 
		killall -15 play
		if [[ $song_count -gt 1 ]]
		then
			# decrementing the song_count to select the next song in songsList.txt
			song_count=$((song_count-1))
			# pick the song name from the list to be played according to the song_count value
			next_song=`sed -n "$song_count{p;q}" /mp3overlay/songsList.txt`			
			# this only for debugging 
			echo "prevsongIf= $next_song" >> /mp3overlay/debug.txt
			echo "prevcountIf= $song_count" >> /mp3overlay/debug.txt
		else
			# reset the song_count to start the list from the last song  
			song_count=$total_songs_num
			# pick the song name from the list to be played according to the song_count value
			next_song=`sed -n "$song_count{p;q}" /mp3overlay/songsList.txt`			
			# this only for debugging 
			echo "prevsongElse= $next_song" >> /mp3overlay/debug.txt
			echo "prevcountElse= $song_count" >> /mp3overlay/debug.txt
		fi	
		# run the song in the background
		lame --quiet --decode /$next_song - | play -q - &
		# make sure that the pause_play_flag is cleared
		pause_play_flag=0
		echo "0" > /mp3overlay/prev_button.txt
		# this only for displaying songs name	
		echo "MP3 Playing > $next_song" > /mp3overlay/song_status.txt
		# to avoid button debouncing 
		sleep 0.5
	fi

	# shuffle button is pressed
	if [[ $(cat /sys/class/gpio/gpio16/value) -eq 1 ]] || [[ "$shuffle_button" -eq 1 ]]
	then
		random_song=$((RANDOM%total_songs_num+1))			
		next_song=`sed -n "$random_song{p;q}" /mp3overlay/songsList.txt`
		# end any running process 
		killall -15 play
		lame --quiet --decode /$next_song - | play -q - &
		# make sure that the pause_play_flag is cleared
		pause_play_flag=0
		# this only for displaying songs name	
		echo "MP3 Playing > $next_song" > /mp3overlay/song_status.txt
		# resetting the flag
		shuffle_button=0
		echo "0" > /mp3overlay/shuffle_button.txt
		# to avoid button debouncing 
		sleep 0.5
	fi
	
done
