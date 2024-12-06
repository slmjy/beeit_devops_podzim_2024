#!/bin/bash
echo "What woul you like to do?"
echo "DIR - Create new directory"
echo "FILE - Create new file"
echo " LINE - insert line into file"
echo "HARD - create hard link"
echo "SOFT - create soft link"
echo "NET - your net information"
echo "IP - your IP address"
echo "MAC - your Mac address"
echo "PING - find IP address from host name"
echo "HOST - find all IP address from host name"
echo "DOCKER - show docker"
echo "IMAGES - all images"
echo "CIMAGE - lookup for current image"
echo "KILL - kill process"
read vstup
case $vstup in 
	DIR)
		read -p "enter directory "  DIR
 		if [ -d "$DIR" ]; then
			echo "directory $DIR already exist"
			sleep 1
		else
	        	mkdir -p $DIR
	        	echo "creating $DIR"
	       	fi;;
	FILE)
		read -p "enter file name: " FILE
		if [ -f "$FILE" ]; then
		       echo "file $FILE already exist"
	       	  	sleep 1
	 	else
			touch  $FILE
			echo "Creating $FILE"
		fi;;
	LINE)
		read -p "write what you want to insert " LINE
		if [ -f "$FILE" ]; then
			$LINE >> $FILE
			echo "Inserting your line"
		else
				echo "Your file don't exist, first create a file"		
				fi;;
	NET)
		echo "Tvoje síťové nastavení je: "
		ifconfig;;
	
	IP)
		echo "Tvoje IP adresa je:"
				ifconfig | grep inet;;
	MAC)
		echo "Tvoje MAC addresa je: "
		ifconfig | grep ether;;
		
	PING)		
		read -p "Write host name: " HOSTNAME
		ping -c 2 $HOSTNAME;;
	HOST)
		read -p "Write host name: " HOSTNAME
		host $HOSTNAME;;
	DOCKER)
		echo "Vypsání dockeru: "
		docker ps;;
	IMAGES)
		echo "Vypsání všech images: "
		docker images ls;;
	CIMAGE)
		read -p "enter your repository for lookup inages "  REP
		if [docker image $REP ]; then
			 echo "images for repository $DIR exist"
			 sleep 1
             	else
			echo "image for reporsitory doesn't exist"
			error 20
		fi;;
	KILL)
		read "enter which ID proccess do you want to kill: " KILL
		if [$KILL = 1]; then
			echo "process ID 1 can't be deleted"
			sleep 1
		else 
			kill $KILL
		fi;;
			

	esac

		