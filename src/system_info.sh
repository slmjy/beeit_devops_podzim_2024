#!/bin/bash

# This is homework No. 3.: Vložte sem kód příkazů, které zjistí více informací o Linux systému a hezky je vypíší.

# touch LinuxOS_informations_about.txt #create an empty file with the name "LinuxOS_informations_about.txt"
# echo "This script is to give you some information about your Linux operating system - if you have it on your computer installed." >> LinuxOS_informations_about.txt

touch LinuxOS_informations_about.txt && echo "--- This script is to give you some information about your Linux operating system (if you have it on your computer installed.. ). ---" > LinuxOS_informations_about.txt 2>&1

echo "  This computer's kernel name is:" >> LinuxOS_informations_about.txt 2>&1
uname -s >> LinuxOS_informations_about.txt 2>&1  # print the kernel name

echo "  The network node hostname is:" >> LinuxOS_informations_about.txt 2>&1
uname -n >> LinuxOS_informations_about.txt 2>&1  # print the network node hostname

echo "  This computer's kernel version is:" >> LinuxOS_informations_about.txt 2>&1
uname -v >> LinuxOS_informations_about.txt 2>&1  # print the kernel version

echo "  This computer's operating system is:" >> LinuxOS_informations_about.txt
uname -o >> LinuxOS_informations_about.txt 2>&1  # print the operating system

echo "  This computer's kernel release is:" >> LinuxOS_informations_about.txt
uname -r >> LinuxOS_informations_about.txt 2>&1  # print the kernel release

cat LinuxOS_informations_about.txt; echo "--- This is the end of the script. ---"
# cat LinuxOS_informations_about.txt  #show/display content of the file "LinuxOS_informations_about.txt" in this console/terminal

# Níže jsou příkazy od Daniely.
# uname -s
# uname -r
# uname -v
# uname -n
# uname -m
# uname -p
# uname -i
# uname -o
# uname -a
