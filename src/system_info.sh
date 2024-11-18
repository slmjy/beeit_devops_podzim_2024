# Sem vložte kód příkazů, které zjistí více informací o Linux systému a hezky je vypíší

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
