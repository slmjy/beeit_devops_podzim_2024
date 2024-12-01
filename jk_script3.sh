#!/bin/bash

#vytvoreni adresare a souboru v nem
echo "vytvoreni adresare a souboru"
echo "============================"
TARGET_DIR="BeeItScripts"
TARGET_FILE="example_file1.txt"
mkdir -p "$TARGET_DIR"
echo "Domaci ukol cislo 3" > "$TARGET_DIR/$TARGET_FILE"
echo "Soubor $TARGET_FILE vytvoren v adresari $TARGET_DIR"
echo "============================"
#vytvoreni soft a hard linku
echo "skript vytvori soft a hard link na vyse uvedeny soubor v /tmp"
ln -s "$(pwd)/$TARGET_DIR/$TARGET_FILE" /tmp/soft_link_example_file1.txt
ln "$(pwd)/$TARGET_DIR/$TARGET_FILE" /tmp/hard_link_example_file1.txt
echo "Soft a Hard link vytvoren"
echo "============================"
#vypise vsechny instalovane balicky
echo "===Vypis vsech instalovanych balicku==="
dpkg --get-selections
echo "===Konec vypisu==="
echo "===Overeni zda je nainstalovan Docker==="
dpkg -l | grep docker
which docker
docker --version
echo "========================================"
echo "===Vypis balicku ktere je mozne upgradovat==="
apt list --upgradable
echo "============================================="
