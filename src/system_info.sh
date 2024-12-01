#!/bin/bash
#skript vypise zakladni info o systemu
echo -e "\e[1;36m====Informace o systemu===\e[0m"
echo "Hostname: $(hostname)"
echo "Uzivatel: $(whoami)"
echo "Distibuce: $(lsb_release -d | cut -f2)"
echo "Verze jadra: $(uname -r)"
echo "Architektura: $(uname -m)"
#
echo -e "\e[1;36m====Informace o CPU===\e[0m"
grep "model name" /proc/cpuinfo | uniq | cut -d':' -f2 | sed 's/^ //'
echo "Pocet jader: $(nproc)"
#
echo -e "\e[1;36m====Informace o RAM===\e[0m"
free -h | awk '/^Mem:/ {print "Celkem: "$2", Pouzito: "$3 ", Volno: "$4}'
#
echo -e "\e[1;36m====Informace o Disku===\e[0m"
df -h --total | awk '/^total/ {print "Celkem: "$2", Pouzito: "$3", Volno: "$4}'
#
echo -e "\e[1;36m====Informace o pripojeni===\e[0m"
ip addr | grep 'inet ' | awk '{print $2 " na rozhrani " $NF}'
#
echo -e "\e[1;36m====Uptime===\e[0m"
uptime -p
# dalsi info mozna priste