
# informace o systému
echo “Místo na disku:”
df -h # zobrazí úložiště na disku

echo “Datum:”
date # zobrazí datum 

echo “Využití paměti systému:”
free -h # využití paměti systému

echo ”Procesor:”
lscpu # informace o procesoru

# příkazy typu uname
echo “Operační systém:”
uname 
echo “Hostname:”
uname -s # hostname
echo “Datum vydání OS:”
uname -r  # zobrazí datum vydání OS
echo “Verze OS:”
uname -v # zobrazí verzi OS
echo “Název hardware:”
uname -m 
echo “Architektura:”
uname -p # architektura procesoru

echo “Doba spuštění systému:”
uptime
=======