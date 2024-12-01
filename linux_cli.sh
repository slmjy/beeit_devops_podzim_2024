#!/bin/bash

# vypis napovedy
usage(){
    echo_blue "Pouziti: $0 [options]"
    echo_blue "Moznosti:"
    echo_red "  -createDirAndFile -dir <nazev_adresare> -file <nazev_souboru>  Vytvori adresar a soubor"
    echo_red "  -createLinks -target <cil_souboru>                             Vytvori soft a hard linky"
    echo_red "  -listPackages                                                  Vypise vsechny nainstalovane balicky"
    echo_red "  -checkDocker                                                   Overi, zda je nainstalovan Docker"
    echo_red "  -listUpgradable                                                Vypise balicky, ktere je mozne upgradovat"
    echo_red "  -getInterfaces                                                 Vypise vsechny sitove rozhrani"
    echo_red "  -getIpMac                                                      Vypise IP a MAC adresu pro vsechna rozhrani"
    echo_red "  -ping -target <IP_adresa>                                      Ping na cilovou IP adresu"
    echo_red "  -getIpFromHost -host <hostname>                                Ziska IP adresy z hostnamu"
    echo_red "  -help                                                          Zobrazi tuto napovedu"
    exit 0
}

# vypis v barvach
echo_red(){
	echo -e "\033[0;31m$1\033[0m"
}
echo_bold_red(){
	echo -e "\033[1;31m$1\033[0m"
}
echo_blue(){
	echo -e "\033[0;34m$1\033[0m"
}
echo_green(){
	echo -e "\033[0;32m$1\033[0m"
}

# funkce pro vytvoreni adresare a souboru
create_dir_and_file(){
	local dir="$1"
	local file="$2"
		if [ -z "$dir" ] || [ -z "$file" ]; then
        	echo "Chyba: Musite zadat adresar i soubor." >&2
        	return 1
        	fi 
 
    	mkdir -p "$dir" || { echo "Chyba: Nepodarilo se vytvorit adresar $dir." >&2; return 2; }
    	echo "" > "$dir/$file" || { echo "Chyba: Nepodarilo se vytvorit soubor $file." >&2; return 3; }
   	echo "Soubor $file vytvoren v adresari $dir."
    	return 0
}

# funkce pro vytvoreni soft a hard linku
create_links(){
   	local target="$1"
	   if [ -z "$target" ] || [ ! -f "$target" ]; then
           echo "Chyba: Musite zadat existujici cilovy soubor." >&2
           return 1
    	   fi
    	ln -s "$target" /tmp/soft_link_"$(basename "$target")" || { echo "Chyba: Nepodarilo se vytvorit soft link." >&2; return 2; }
    	ln "$target" /tmp/hard_link_"$(basename "$target")" || { echo "Chyba: Nepodarilo se vytvorit hard link." >&2; return 3; }
    	echo "Soft a hard link vytvoreny pro soubor $target."
    	return 0
}

# funkce pro vypis vsech nainstalovanych balicku
list_packages() {
    apt list --installed || { echo "Chyba: Nepodarilo se ziskat seznam balicku." >&2; return 1; }
    return 0
}

# funkce pro vypis balicku, ktere je mozne upgradovat
list_upgradable() {
    apt list --upgradable || { echo "Chyba: Nepodarilo se zjistit upgradovatelne balicky." >&2; return 1; }
    return 0
}

# funkce pro overeni Dockeru
check_docker() {
    apt list --installed | grep docker || { echo "Docker neni nainstalovan nebo nenalezen v seznamu balicku." >&2; }
    which docker || { echo "Chyba: Docker neni dostupny v PATH." >&2; return 1; }
    docker --version || { echo "Chyba: Nepodarilo se zjistit verzi Dockeru." >&2; return 1; }
    echo "Docker je nainstalovan a dostupny."
    return 0
}

# NOVE PRIDANE FUNKCE
# funkce pro ziskani vsech sitovych rozhrani
get_interfaces() {
    ip link show || { echo "Chyba: Nepodarilo se ziskat seznam sitovych rozhrani." >&2; return 1; }
    return 0
}

# funkce pro ziskani IP a MAC adresy
get_ip_mac() {
    ip -o -4 addr show | awk '{print "Rozhrani: "$2", IP: "$4}' || { echo "Chyba: Nepodarilo se zjistit IP adresy." >&2; return 1; }
    ip link show | awk '/link\/ether/ {print "Rozhrani: "$2", MAC: "$2}' || { echo "Chyba: Nepodarilo se zjistit MAC adresy." >&2; return 1; }
    return 0
}

# funkce pro ping na cílovou IP adresu
ping_target() {
    local target="$1"
    if [ -z "$target" ]; then
        echo "Chyba: Musite zadat cilovou IP adresu." >&2
        return 1
    fi
    ping -c 4 "$target" || { echo "Chyba: Ping na $target selhal." >&2; return 1; }
    return 0
}

# funkce pro ziskani IP adres z hostname
get_ip_from_host() {
    local host="$1"
    if [ -z "$host" ]; then
        echo "Chyba: Je treba zadat hostname." >&2
        return 1
    fi
    getent hosts "$host" | awk '{print $1}' || { echo "Chyba: Nepodarilo se ziskat IP adresy z hostname $host." >&2; return 1; }
    return 0
} 


#---------------------------------------------------------------------------
# zpracovani vstupnich argumentu
if [ $# -eq 0 ]; then
    echo "Chyba: Nebyly zadany zadne argumenty." >&2
    usage
fi
while [[ $# -gt 0 ]]; do
    case "$1" in
        -createDirAndFile)
            ACTION="createDirAndFile"
            shift
            ;;
        -dir)
            DIR_NAME="$2"
            shift 2
            ;;
        -file)
            FILE_NAME="$2"
            shift 2
            ;;
        -createLinks)
            ACTION="createLinks"
            shift
            ;;
        -target)
            TARGET="$2"
            shift 2
            ;;
        -listPackages)
            ACTION="listPackages"
            shift
            ;;
        -checkDocker)
            ACTION="checkDocker"
            shift
            ;;
        -listUpgradable)
            ACTION="listUpgradable"
            shift
            ;;
	-getInterfaces)
            ACTION="getInterfaces"
            shift
            ;;
        -getIpMac)
            ACTION="getIpMac"
            shift
            ;;
        -ping)
            ACTION="ping"
            shift
            ;;
        -getIpFromHost)
            ACTION="getIpFromHost"
            shift
            ;;
        -host)
            HOST="$2"
            shift 2
            ;;
        -help)
            usage
            ;;
        *)
            echo_bold_red "Chyba: Neznama moznost $1." >&2
            usage
            ;;
    esac
done

# provedeni akce
case "$ACTION" in
    createDirAndFile)
        create_dir_and_file "$DIR_NAME" "$FILE_NAME"
        exit $?
        ;;
    createLinks)
        create_links "$TARGET"
        exit $?
        ;;
    listPackages)
        list_packages
        exit $?
        ;;
    checkDocker)
        check_docker
        exit $?
        ;;
    listUpgradable)
        list_upgradable
        exit $?
        ;;
    getInterfaces)
        get_interfaces
        exit $?
        ;;
    getIpMac)
        get_ip_mac
        exit $?
        ;;
    ping)
        ping_target "$TARGET"
        exit $?
        ;;
    getIpFromHost)
        get_ip_from_host "$HOST"
        exit $?
        ;;
    *)
        echo_bold_red "Chyba: Nebyla zvolena platna akce." >&2
        usage
        ;;
 esac

