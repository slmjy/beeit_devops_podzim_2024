# Sem vložte kód příkazů, které zjistí více informací o Linux systému a hezky je vypíší
<<<<<<< HEAD

#!/bin/bash

echo "==== Informace o systému ===="
echo "Hostname: $(hostname)"
echo "Uživatel: $(whoami)"
echo "Datum a čas: $(date)"
echo
echo "==== Informace o systému ===="
uname -a
echo
echo "==== Informace o distribuci ===="
cat /etc/os-release
echo
echo "==== Využití disku ===="
df -h
echo
echo "==== Paměť ===="
free -h
echo
echo "==== Uptime ===="
uptime
echo
echo "==== Aktivní uživatelé ===="
who
=======
uname -s
uname -r
uname -v
uname -n
uname -m
uname -p
uname -i
uname -o
uname -a
>>>>>>> f777492e545e38e0a43518433861485864db1a60
