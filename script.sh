mkdir ./DMIL
echo "Vytváram adresír DMIL"
echo "---------------------"

touch "/DMIL/test.txt"
echo "Vytváram súbor test.txt"
echo "-----------------------"

cat > test.txt
Zapisujem do súboru - učím sa s Linuxem.
echo "Zapisujem do súboru test.txt riadok Zapisujem do súboru - učím sa s Linuxem"
echo "---------------------------------------------------------------------------"

mkdir ./DMIL/tmp
ln -s ./DMIL/test.txt ./DMIL/tmp/soft_link_test
echo " Vytváram soft link suboru test.txt do adresára tmp"

ln ./DMIL/test.txt ./DMIL/tmp/hard_link_test
echo " Vytváram hard link súboru test.txt do adresíra tmp"

apt list --installed
echo "Vypisujem nainštalované balíčky"

apt list installed grep docker
echo "vyhledáva docker balíčky"

apt list --upgradable
echo "Balíčky ktoré možu by(t upgradované
