#!/bin/bash

DIR="system_scripts"
mkdir ./$DIR
echo "Prepared a new directory called $DIR"
echo "==============================="

FILE="system_packages.txt"
touch ./$DIR/$FILE
echo "Prepared a new file called $FILE inside directory $DIR"
echo "==============================="

echo "Random content" > ./$DIR/$FILE
echo "Added a new line into $FILE"
echo "==============================="

echo "Assigning editing right to everyone for file: $DIR/$FILE..."
chmod 766 ./$DIR/$FILE
echo "==============================="

ln -s ./$DIR/$FILE /tmp/soft_link_system_packages
ln ./$DIR/$FILE /tmp/hard_link_system_packages
echo "Created soft & hard links for file: $DIR/$FILE"
echo "==============================="

echo "Currently installed packages:"
apt list --installed
echo "==============================="

echo "Listing docker package:"
apt list --installed | grep docker
echo "==============================="

echo "Packages which might be updated:"
apt list --upgradable
echo "==============================="
