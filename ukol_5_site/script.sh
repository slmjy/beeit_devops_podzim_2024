#!/bin/bash
set -e


Help()
 {
     # show Help
      echo " Nápověda"
      echo
      echo " g		    Získání IP adresy z hostname"
      echo " 		    Příklad zápisu: -g -h google.com"
      echo " p		    Ping"
      echo "	            Příklad zápisu: -p -h google.com"
      echo " t		    Hostname"
      echo " f		    Vypíše všechen interface případně zadání vlastního interface pro IP či MAC adresu"
      echo "		    Příklad zápisu: -i -m -f eth0"
      echo " i              Vypíše IP adresu"
      echo " m              Vypíše MAC adresu "
      echo " h              Nápověda"
      

 }

Find_IP()
{
     # najdi_ip_adresu"
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
Legit_Interface()
{ # kontrola_interface

 if ! ip link show "$1" > /dev/null 2>&1; then
 	echo "CHYBA: Špatně zadané či neexistující rozhraní "$INTERFACE"" >&2
	exit 1
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
while getopts himn:fpt:g OPT
 do
	  case "${OPT}" in
        	 h) # show Help
           	    Help;;
   	         i) IP=1 ;;
       		 m) MAC=1 ;;
		 n) INTERFACE="${OPTARG}";; 
		 f) INFACE=1 ;;
		 g) GETIP=1;;
		 p) PING=1;;
		 t) TARGET="${OPTARG}";;
		
        	 *) echo "Neplatná volba" >&2
	            exit 1;;
 	 esac
 done
if [ -z "$INTERFACE" ]; then 
	INTERFACE="eth0"
fi

Legit_Interface "$INTERFACE"


if [ -n "$IP" ]; then 
	Find_IP 
	if [ -z "$MAC" ]; then
		echo "Přejete si vypast i MAC adresu ? (Y/N)"
		read ROZH

		if [ "$ROZH" = "Y" ] || [ "$ROZH" = "y" ]; then
			Find_MAC
			
		elif [ "$ROZH" = "N" ] || [ "$ROZH" = "n" ]; then
			echo "MAC adresa nezobrazena"
		else
			echo "Neplatný vstup" >&2
			exit 1
		fi
	fi
fi
 
if [ -n "$MAC" ]; then
	Find_MAC

fi
if [ -n "$INFACE" ]; then
	Write_Interface

fi

if [ -n "$PING" ]; then
	Ping
fi
if [ -n "$GETIP" ]; then
	Get_IP
fi
