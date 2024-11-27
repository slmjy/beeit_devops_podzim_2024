#!/bin/bash
echo "What woul you like to do?"
echo "DIR - Create new directory"
echo "FILE - Create new file"
echo " LINE - insert line into file"
echo "HARD - create hard link"
echo "SOFT - create soft link"

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
	esac
