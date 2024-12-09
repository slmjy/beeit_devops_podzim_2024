#!/bin/bash
set +e
set +x 
Help()
{
  # show Help
  echo " Nápověda"
  echo  
  echo " -makeDir		Pro vytvoření složky"
  echo " -path			Pro cestu k souboru"
  echo " -h			Nápověda"
  echo "Příklad:        ./script.sh -mkdir  složka  -path home/usr/moje_data"
  echo
  echo " -inst_pack		Seznam nainstalovaných balíčků"
  echo " -find_docker   	Najde docker balíček"
  echo " -apt_uprg		Seznam nainstalovaných balíčků, u nichž je možné provést update"
  echo
  echo " -find_IP		Vypíše IP adresu zařízení"
  echo " -find_MAC      	Vypíše MAC adresu zařízení"
  echo " -interface    		Zadání vlastního interface pro zjištění MAC nebo IP adresy (základní nastavení eth0)"
  echo "Příklad použití: ./script.sh -find_IP -interface eth0"
  echo 
  echo " -ping			Prověření funkčnosti Hosta"
  echo "Příklad použití: ./script.sh -ping seznam.cz"
  echo
  echo " -get_IP        	Vypíše IP adresu podle hostname"
  echo " Příklad použití: ./script.sh -get_IP seznam.cz "
  echo""
  echo " -dock_list      	Vypsání dockeru"
  echo " -dock_image_all	Vypíše všechny image "
  echo " -dock_find_image	Nalezení image dle jména"
  echo " Příklad použití: ./script.sh -dock_find_image -image ubuntu"
  echo " -dock_find_cont        Nalezení kontejneru dle jména, v případě vypsání "unknown" vypíše seznam kontejneru v dané image"
  echo " Příklad použití ./script.sh -dock_find_cont -image ubuntu -container unknown"
  echo " -kill			Zastavení procesu v volbou způsobu, pro vypsání možností zvolte parametr -h"
  echo " Příklad použití ./script.sh -kill 9 -container elegant_clarke -PID 265"
}


New_Name()
{
    # rename file
	echo "Zadejte nový název"
        read Name_New
        mkdir $Name_New
	echo "Název změněn na $Name_New"
        exit 0
}


New_Name_W_Directory()
{
     # rename file with directory
         echo "Zadejte nový název"
         read New_Nam
         mkdir /$DIRECTORY/$New_Nam
         exit 0
}
Bad_Income()
{   # spatny_vstup
    	echo "Neplatný vstup" >&2
	exit 1
}
No_Rights()
{ #nema_prava
	if [ ! -w "$FILE_NAME" ]; then
	 echo "CHYBA, Nemáte dostatečná práva pro provedení operace" >&2
  	 exit 1
	fi
}
Soft_Link()
{  # create soft_link
 echo "Chcete  a) vytvoření  soft_linku na zvolené adrese nebo b) chcete soft_link na aktuální adrese ? "
 read ROZH
 if [ "$ROZH" = "a" ] || [ "$ROZH" = "A" ]; then
      echo "Zadejte cestu :"
      read New_Path
      if [ -e "$New_Path" ]; then
     	 ln -s "$DIRECTORY/$FILE_NAME" "$New_Path/$FILE_NAME"
      	 if [ $? -eq 0 ]; then 
         	echo "Soft_Link souboru $Main_File na adrese $Direct_New vytvořen "
         	return 0 
      	 else
         	echo "Nemáte oprávnění pro vytvoření soft_linku" >&2
        	return 1
      	 fi
     else
	echo "Neplatná cesta" >&2
	return 1
     fi
  elif [ "$ROZH" = "B" ] || [ "$ROZH" = "b" ]; then
	Actual_Path=$(pwd)
        ln -s "$DIRECTORY/$FILE_NAME" "$Actual_Path/$FILE_NAME"
     if [ $? -eq 0 ]; then
        echo "Soft_Link souboru $Main_File na adrese $Direct_New vytvořen "
        return 0
     else
         echo "Nemáte oprávnění pro vytvoření soft_linku" >&2
         return 1
     fi
  else
    Bad_Income
 fi
}
File_W_Adress()
{
   # make File_W_Adress
   if [ -d "/$DIRECTORY/$FILE_NAME" ]; then
      echo "Složka již existuje, přejete si ji nahradit (N)?"
      echo "nebo přejmenovat ? (P)"
      read ROZHODNUTI3

      if [ "$ROZHODNUTI3" = "N" ] || [ "$ROZHODNUTI3" = "n" ]; then
         if [ -z "$(ls -A "/$DIRECTORY/$FILE_NAME")" ]; then
            rmdir "/$DIRECTORY/$FILE_NAME"  
            mkdir -p "/$DIRECTORY/$FILE_NAME"
            echo "Stará složka je prázdná a tak je nová složka vytvořena. Přejete si vytvořit soft_link? (Y/N)"
               read ROZHODNUTSOFT
                
                  if [ "$ROZHODNUTSOFT" = "Y" ] || [ "$ROZHODNUTSOFT" = "y" ]; then
		        Soft_Link
		  elif [ "$ROZHODNUTSOFT" = "N" ] || [ "$ROZHODNUTSOFT" = "n" ]; then
			echo "Soft_Link nevytvořen na rozhodnutí uživatele"
			return 0
		  else
			Bad_Income
		  fi
         else
            echo "Stará složka obsahuje soubory a nelze tak vytvořit novou. Zde je její obsah:"
            echo $(ls "/$DIRECTORY/$FILE_NAME")
            echo "Přejete si smazat starou složku i se stávajícími soubory ? (Y)"
	    echo "Nebo změnit název (N) či odejít (E) ?"
            read ROZHODNUTI4

            if [ "$ROZHODNUTI4" = "Y" ] || [ "$ROZHODNUTI4" = "Y" ]; then
               rm -rf "/$DIRECTORY/$FILE_NAME"  
               mkdir -p "/$DIRECTORY/$FILE_NAME"
               echo "Složka $FILE_NAME s adresou $DIRECTORY přepsána"
            elif [ "$ROZHODNUTI4" = "N" ] || [ "$ROZHODNUTI4" = "n" ]; then
               New_Name_W_Directory
               echo "Složka $FILE_NAME vytvořena na adrese $DIRECTORY. Přejete si vytvořit soft-link (Y/N)"
                 read ROZHODNUTSOFT2
  
                    if [ "$ROZHODNUTSOFT2" = "Y" ] || [ "$ROZHODNUTSOFT2" = "y" ]; then
                          Soft_Link
                    elif [ "$ROZHODNUTSOFT2" = "N" ] || [ "$ROZHODNUTSOFT2" = "n" ]; then
                          echo "Soft_Link nevytvořen na rozhodnutí uživatele"
                          return 0
		    else 
			  Bad_Income	
		    fi
               
	    elif [ "$ROZHODNUTI4" = "E" ] || [ "$ROZHODNUTI4" = "e" ]; then
		echo "Program ukončen uživatelem "
		exit 0
            else
              Bad_Income
            fi
        fi
       elif [ "$ROZHODNUTI3" = "P" ] || [ "$ROZHODNUTI3" = "p" ]; then
            New_Name_W_Directory
		echo "Přejete si vytvořit soft-link (Y/N)"
                 read ROZHODNUTSOFT3
  
                    if [ "$ROZHODNUTSOFT3" = "Y" ] || [ "$ROZHODNUTSOFT3" = "y" ]; then
                         Soft_Link
                    elif [ "$ROZHODNUTSOFT3" = "N" ] || [ "$ROZHODNUTSOFT3" = "n" ]; then
                          echo "Soft_Link nevytvořen na rozhodnutí uživatele"
                         return 0
		    else
			Bad_Income
                    fi
       else 
          Bad_Income
       fi
   else
    mkdir -p "/$DIRECTORY/$FILE_NAME"
    echo "Složka $FILE_NAME na adrese $DIRECTORY vytvořena"
    echo "Přejete si vytvořit Soft_Link (Y/N) ?"
     read ROZHODNUTSOFT4
          if [ "$ROZHODNUTSOFT4" = "Y" ] || [ "$ROZHODNUTSOFT4" = "y" ]; then
                 Soft_Link
           elif [ "$ROZHODNUTSOFT4" = "N" ] || [ "$ROZHODNUTSOFT4" = "n" ]; then
                  echo "Soft_Link nevytvořen na rozhodnutí uživatele"
                  return 0
	   else
		Bad_Income
           fi 
  fi
}
File()
{
  # make File
       echo "Nebyla zadána cesta pro soubor, Chcete jej umístit na aktuální adrese $pwd Y/N?"
       read ROZHODNUTI 
       if [ "$ROZHODNUTI" = "Y" ] || [ "$ROZHODNUTI" = "y" ]; then
 
          
          if [ -e "$FILE_NAME" ]; then
               echo "Složka již existuje, přejete si jej  nahradit (Y) "
               echo "Nebo změnit název ? Stiskni (A)"
	       echo "Nebo program ukončit ? (E)"
               read ROZHODNUTI1

              if [ "$ROZHODNUTI1" = "Y" ] || [ "$ROZHODNUTI1" = "y" ]; then
                   if [ -z "$(ls -A "$FILE_NAME")" ]; then
                        No_Rights
			rmdir "$FILE_NAME"
                        mkdir "$FILE_NAME"
                        echo "Stará složka je prázdná a tak je nová složka vytvořena"
                        exit 0
                   else 
                        echo "Stará složka obsahuje soubory a nelze tak vytvořit novou. Zde je její obsah:"
                        echo $(ls "$FILE_NAME" )
                        echo "Přejete si smazat starou složku i se stávajícími soubory ? Y/N"
                        read ROZHODNUTI2

                               if [ "$ROZHODNUTI2" = "Y" ] || [ "$ROZHODNUTI2" = "y" ]; then
                                    No_Rights
				    rm -rf "$FILE_NAME"
                                    mkdir "$FILE_NAME"
                                    echo "Složka přepsána a obsah smazána"
                                    exit 0

                              elif [ "$ROZHODNUTI2" = "N" ] || [ "$ROZHODNUTI2" = "n" ]; then
	                          echo "Přejete si ted změnit název (N) nebo adresu (A) nebo program ukončit (E) ?"
				  read ROZHODNUTIX
	                           if [ "$ROZHODNUTIX" = "N" ] || [ "$ROZHODNUTIX" = "n" ]; then
					New_Name
				   elif [ "$ROZHODNUTIX" = "a" ] || [ "$ROZHODNUTIX" = "A" ]; then
	                                echo "Zadej novou adresu: "
					read New_Adress
					mkdir "$New_Adress/$FILE_NAME"
					return 0
		       		  elif [ "$ROZHODNUTI4" = "E" ] || [ "$ROZHODNUTI4" = "e" ]; then
 			                 echo "Program ukončen uživatelem "
 					 exit 0
				   else
				    Bad_Income
                                   fi
                              else
                                Bad_Income
                              fi
                 fi
              elif [ "$ROZHODNUTI1" = "A" ] || [ "$ROZHODNUTI1" = "a" ]; then
                    New_Name
                    echo "Složka $New_Name vytvořena na adrese $DIRECTORY"
                    exit 0
	      elif [ "$ROZHODNUTI4" = "E" ] || [ "$ROZHODNUTI4" = "e" ]; then
                    echo "Program ukončen uživatelem "
                    exit 0
             else
                    Bad_Income
             fi

       else
        mkdir "$FILE_NAME"
        echo "Soubor $FILE_NAME vytvořen"
        exit 0
       fi
      elif [ "$ROZHODNUTI" = "N" ] || [ "$ROZHODNUTI" = "n" ]; then
         echo "Zadejte adresu:"
         read DIRECTORY
         File_W_Adress
         exit 0
     else
        Bad_Income
    fi
}
Apt_Installed()
{
  # instaled packedges
	echo "Seznam všech nainstalovaných balíčků:"
	apt list --installed
}
Find_Dock()
{
  #searching for docker
	echo "Vyhledání docker balíčku:"
	apt search docker
}
Apt_Uprgrade()
{ 
  #list of upgradable packedges
	echo "Seznam nainstalovaných balíčků, u nichž je možné provést update:"
	apt list --upgradable
}
Legit_Interface()
{ # kontrola_interface

 if ! ip link show "$1" > /dev/null 2>&1; then
 	echo "CHYBA: Špatně zadané či neexistující rozhraní "$INTERFACE"" >&2
	exit 1
 else
	return "$INTERFACE"
 fi

}

Find_IP()
{
     # najdi_ip_adresu"
	if [ -z "$INTERFACE" ]; then
        INTERFACE="eth0"
     else
	Legit_Interface "$INTERFACE"
     fi
		 if command -v ifconfig > /dev/null 2>&1; then
			echo "Přejete si vypsat pouze vytaženou IP adresu (Y/N)"	
			read VOLBA1			
				 if [ "$VOLBA1" = "Y" ] || [ "$VOLBA1" = "y" ]; then
					ip addr show "$INTERFACE" | grep -oP 'inet \K[\d.]+'
				
				elif [ "$VOLBA1" = "n" ] || [ "$VOLBA1" = "N" ]; then
					ifconfig "$INTERFACE"
				
				 else   
					echo "Neplatný vstup" >&2
					exit 1
				fi
	 	else
 	   		echo "Nemáte nainstalovaný potřebný nástroj."
			echo "Přejete si jej nainstalovat (Y/N)"
			read VOLBA

			if [ "$VOLBA" = "y" ] || [ "$VOLBA" = "Y" ]; then
				sudo apt install net-tools
				echo "Nástroj nainstalován. Provedu kontrolu ....."
				exec "$0"
			elif [ "$VOLBA" = "n" ] || [ "$VOLBA" = "N" ]; then
				echo "Konec programu"
			
			else
				echo "Neplatný vstup" >&2
				exit 1
			fi

		 fi


}

Find_MAC()
{  
    # najdi_mac_adresu
	
  if [ -z "$INTERFACE" ]; then 
	INTERFACE="eth0"
  else
     Legit_Interface "$INTERFACE"
  fi
	echo "Přejete si vypsat pouze extrahovanou MAC adresu ? (Y/N)"
	read VOLBAX
	

	if [ "$VOLBAX" = "Y" ] || [ "$VOLBAX" = "y" ]; then
		ip addr show "$INTERFACE" | grep -oP 'link/ether \K([0-9a-f]{2}:){5}[0-9a-f]{2}'
	
	elif [ "$VOLBAX" = "n" ] || [ "$VOLBAX" = "N" ]; then
		ip addr show "$INTERFACE"

	else
		echo "Neplatný vstup" >&2
		exit 1
	fi
}

Write_Interface()
{
	#vypis_interface 
	if command -v tcpdump > /dev/null 2>&1; then
		tcpdump --list-interfaces
	else
		 echo "Nemáte nainstalovaný potřebný nástroj."
                  echo "Přejete si jej nainstalovat (Y/N)"
                  read VOLBA2
  
                  if [ "$VOLBA2" = "y" ] || [ "$VOLBA2" = "Y" ]; then
                                  sudo apt  install tcpdump  # version 4.99.4-3ubuntu1
                                  echo "Nástroj nainstalován. Provedu kontrolu ....."
                                  exec "$0"
                   elif [ "$VOLBA2" = "n" ] || [ "$VOLBA2" = "N" ]; then
                                  echo "Nástroj nenainstalován"
  
                   else
                                  echo "Neplatný vstup" >&2
                                  exit 1
                   fi
	fi
}

Ping()
{ #ping_a_target

 if [ -n "$TARGET" ]; then
	if command -v ping > /dev/null 2>&1; then
 		if ping -c 1 "$TARGET"; then
			ping -w 20 "$TARGET"
		else
			echo "CHYBA: $TARGET je neplatný hostname"  >&2
			exit 1
		fi
	else
		echo "Nemáte nainstalovaný potřebný nástroj."
		echo "Přejete si jej nainstalovat (Y/N)"
		read VOLBA3
		
		 if [ "$VOLBA3" = "y" ] || [ "$VOLBA3" = "Y" ]; then
			apt-get install iputils-ping -y
			echo "Nástroj nainstalován. Provedu kontrolu ....."
			exec "$0"
		elif [ "$VOLBA3" = "n" ] || [ "$VOLBA3" = "N" ]; then
			echo "Nástroj nenainstalován"
		else
			echo "Neplatný vstup" >&2
			exit 1
		fi
	fi
 else
	echo "CHYBA: Nezadán cíl"  >&2
	exit 1
 fi
}
Get_IP()
{
# get_IP_from_Hostname
 if [ -n "$TARGET" ]; then
 	if host "$TARGET" > /dev/null 2>&1; then
		IP_Adresa=$( host "$TARGET" | grep -oP 'address \K[\d.]+' )
		echo "IP adresa "$TARGET" je "$IP_Adresa" "
	else
		echo "CHYBA: Nepodařilo se získat ID zkuste zkontrolovat zápis hostname" >&2
		exit 1
	fi
 else
	echo "CHYBA: Hostname nazadán" >&2
	exit 1
 fi
}
Docker_Pull()
{ #pull_users_docker_container
if command -v docker > /dev/null 2>&1; then
	docker images "$CONTAINER" > /dev/null 2>&1
	if [ $? -eq 0 ]; then
		echo ""$CONTAINER" je už stažen"
	else
		docker pull "$CONTAINER" > /dev/null 2>&1
			if [ $? -eq 0 ]; then
				docker pull "$CONTAINER"
				echo ""$CONTAINER" úspěšně stažen"
			else
				echo "CHYBA: Špatně zadaný název nebo chyba v přípojení" >&2
				exit 1
			fi 
	fi
else
	echo "CHYBA:Nemáte nainstalovaný docker" >&2
	exit 1
fi
}
Listing_Docker()
{ #list_of_running_containers
if command -v docker > /dev/null 2>&1; then
	docker ps > /dev/null 2>&1
	echo "Chcete vypsat pouze aktivní nebo včechny? (active/all)"
	read ROZ
	if [ "$ROZ" = "active" ] || [ "$ROZ" = "Active" ] || [ "$ROZ" = "ACTIVE" ]; then
		if [ $? -eq 0 ]; then
			docker ps

		else
			echo "CHYBA: Nemáte oprávnění nebo správně nakonfigované přípojení" >&2
			exit 1
		fi
	elif [ "$ROZ" = "all" ] || [ "$ROZ" = "All" ] || [ "$ROZ" = "ALL" ]; then
		if [ $? -eq 0 ]; then
                        docker ps -a
         
                 else
                         echo "CHYBA: Nemáte oprávnění nebo správně nakonfigované přípojení" >&2
                         exit 1
		fi
	else
		echo "CHYBA: Neplatný vstup" >&2
		exit 1
	fi
  
else
	echo "CHYBA:Nemáte nainstalovaný docker" >&2
	exit 1
fi
}

Docker_All_Imagine()
{ #list_all_imagines 
if command -v docker > /dev/null 2>&1; then
        docker images -a > /dev/null 2>&1
	if [ $? -eq 0 ]; then
		docker images -a
	else
		echo "CHYBA: Nemáte oprávnění nebo správně nakonfigované přípojení" >&2
		exit 1
	fi
else
	echo "CHYBA:Nemáte nainstalovaný docker" >&2
         exit 1
fi
}


Specific_Image()
{ #find specific image in docker
if command -v docker > /dev/null 2>&1; then
	docker image inspect "$IMAGE" > /dev/null 2>&1
	RESULT=$?
	if [ $RESULT -eq 0 ]; then
		echo ""$IMAGE" existuje"
		docker images "$IMAGE"
		return 0
	else
		echo "CHYBA: "$IMAGE" nenalezen" >&2
		exit 1
	fi
else
	echo "CHYBA:Nemáte nainstalovaný docker" >&2
	exit 1
fi
}
Specifi_Container()
{ #find_container_by_name
if command -v docker > /dev/null 2>&1; then
	if [ "$CONTAINER" = "Unknown" ] || [ "$CONTAINER" = "UNKNOWN" ] || [ "$CONTAINER" = "unknown" ]; then
		CON_LIST=$(docker ps -a --filter "ancestor="$IMAGE"" --format "{{.Names}}")
		echo "Výpis kontejnerů: $CON_LIST"
		exit 0
	else
		IMAGINES_CONTAINER=$(docker ps -a --filter "ancestor="$IMAGE"" --format "{{.Names}}") 
		if [[ "$IMAGINES_CONTAINER" == *"$CONTAINER"* ]]; then
			ID=$( docker ps -aqf "name=$CONTAINER")
			echo "$CONTAINER se nachází v $IMAGE s ID $ID"
		
		else
			echo "$CONTAINER neexistuje v $IMAGE jsou pouze: $IMAGINES_CONTAINER"
			exit 0
		fi
	fi
else
        echo "CHYBA:Nemáte nainstalovaný docker" >&2
	exit 1
fi
}
Process_Kill()
{ #kill_proces
if  [ -n "$PID" ]; then
	if [ $PID -eq 1 ]; then
		echo "CHYBA:Iniciační proces nelze zastavit" >&2
		exit 1
	else
		docker exec "$CONTAINER" kill 0 "$PID" 2>/dev/null
		if [ $? -eq 0 ]; then
			case $CHOICE in 
				1) 
					echo "Restartuji proces $PID v $CONTAINER ......."
					docker exec "$CONTAINER" kill -SIGHUB "$PID";;
				2)
					echo "Pokusím se smazat proces $PID v $CONTAINER ......."
					docker exec "$CONTAINER" kill -SIGINIT "$PID";;
				3)
					echo "Zastavuji proces $PID v $CONTAINER a ukládám informace ......"
					docker exec "$CONTAINER" kill -SIGQUIT "$PID";;
				15)
					echo "Smažu proces $PID v $CONTAINER ........"
					docker exec "$CONTAINER" kill -SIGTERM "$PID";;
				9)
					echo "Zastavuji proces $PID v $CONTAINER ......."
					docker exec "$CONTAINER" kill -SIGKILL "$PID";;
				h)
					echo "-1	SIGHUB		Restartuje proces se stejným PID"
					echo "-2        SIGINT          Zkusí smazat proces, ale né vždy se to může podařit"
					echo "-3        SIGQUIT         Zastaví proces a uloží informace do složky"
					echo "-15       SIGTERM         Smaže proces, základní hodnota"
					echo "-9        SIGKILL         Okamžitě zastaví proces"
					exit 0;;
				*)
					echo "Neplatná volba" >&2
					exit 1;;
		
			esac
		else
			echo "CHYBA: $PID v $CONTAINER neexistuje" >&2
			exit 1
		fi
	fi
else
	echo "Nebylo zadáno PID" >&2
	exit 1
fi
} 

if  [ $# -eq 0 ]; then
	echo "CHYBA: Nezadán žádný argument" >&2
	exit 1
fi
while [[ $# -gt 0 ]]; do
  case "$1" in
     -h) # show Help
	 Help
	 return 0 ;;
     -inst_pack)
         Apt_Installed
         return 0 ;;
     -find_docker)
         Find_Dock
         return 0 ;;
     -apt_uprg)
         Apt_Uprgrade
         return 0 ;;
     -find_IP) 
	Find_IP
	exit 0;;
     -find_MAC)
	Find_MAC
	exit 0 ;;
     -dock_list)
	Listing_Docker
	exit 0;;
     -dock_image_all)
	Docker_All_Imagine
	exit 0;;
     -dock_find_image)
	TASK=Find_Docker_Image
	shift ;;
     -dock_find_cont)
	TASK=Find_Specific_Container
	shift ;;
     -kill)
	if [ -z "$2" ]; then
		echo "CHYBA: Chybí argument" >&2
		exit 1
	fi
	TASK=Kill_Process
	CHOICE="$2"
	shift 2;;
     -image)
	if [ -z "$2" ]; then
		echo "CHYBA: Chybí argument" >&2
		exit 1
	fi
	IMAGE="$2"
	shift 2;;
     -container)
	 if [ -z "$2" ]; then
		 echo "CHYBA: Chybí argument" >&2
		exit 1
	fi
	CONTAINER="$2"
	shift 2;;
     -PID) 
	if [ -z "$2" ]; then
		echo "CHYBA: Chybí argument" >&2
		exit 1
	fi
	PID="$2"
	shift 2;;
     -ping)
	if [ -z "$2" ]; then
                 echo "CHYBA: Chybí argument" >&2
                 exit 1
	fi
	TARGET="$2"
	TASK=Ping_Host
	shift 2;;
     -get_IP) 
	if [ -z "$2" ]; then
                  echo "CHYBA: Chybí argument" >&2
                  exit 1
	fi 
	TARGET="$2"
	TASK=Get_IP_from_Host
	shift 2 ;;	

     -makeDir) 
	if [ -z "$2" ]; then
                  echo "CHYBA: Chybí argument" >&2
                  exit 1
	fi
	TASK="Make_Directory"
	FILE_NAME="$2"
        shift 2 ;;  
     -path) 
	if [ -z "$2" ]; then
                  echo "CHYBA: Chybí argument" >&2
                  exit 1
         fi
	DIRECTORY="$2"
        shift 2 ;; 
     -interface)
	INTERFACE="$2"
	shift 2;; 
    *) echo "CHYBA: Neznámá volba: $1" >&2
       exit 1 ;;
  esac
done

case "$TASK" in
	Ping_Host) 
		Ping "$TARGET"
		exit $?;;
	Get_IP_from_Host)
		Get_IP "$TARGET"
		exit $?;;
	Make_Directory)
		if [ -n "$DIRECTORY" ]; then 
			File_W_Adress "$DIRECTORY""$FILE_NAME" 
		else
			File "$FILE_NAME" 
		fi
		exit $?;;
	Find_Docker_Image)
		Specific_Image "$IMAGE"
		exit $?;;
	Find_Specific_Container)
		Specifi_Container "$IMAGE" "$CONTAINER"
		exit $?;;
	Kill_Process)
		Process_Kill "$CHOICE" "$CONTAINER" "$PID";;
	*)
		echo "CHYBA: Neplatný argument" >&2
		exit 1 ;;
esac 
