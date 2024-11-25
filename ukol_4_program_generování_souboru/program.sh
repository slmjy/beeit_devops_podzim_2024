#!/bin/bash 

set -e
set +x 
Help()
{
  # show Help
  echo " Nápověda"
  echo
  echo " f		Pro vytvoření složky"
  echo " d		Pro cestu k souboru"
  echo " h		Nápověda"
  echo "Příklad:        ./program.sh -f složka -d home/usr/moje_data"
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
            echo "Stará složka je prázdná a tak je nová složka vytvořena"
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
               echo "Složka $FILE_NAME vytvořena na adrese $DIRECTORY"
               exit 0
	    elif [ "$ROZHODNUTI4" = "E" ] || [ "$ROZHODNUTI4" = "e" ]; then
		echo "Program ukončen uživatelem "
		exit 0
            else
              Bad_Income
            fi
        fi
       elif [ "$ROZHODNUTI3" = "P" ] || [ "$ROZHODNUTI3" = "p" ]; then
            New_Name_W_Directory
       else 
          Bad_Income
       fi
   else
    mkdir -p "/$DIRECTORY/$FILE_NAME"
    echo "Složka $FILE_NAME na adrese $DIRECTORY vytvořena"
    exit 0 
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
        mkdir $FILE_NAME
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


while getopts hf:d: OPT
do
 case "${OPT}" in 
	h) # show Help
	   Help;;
        f) FILE_NAME=${OPTARG} ;; 
	d) DIRECTORY=${OPTARG} ;; 
        *) echo "Neplatná volba" >&2 
		exit 1;;
 esac 
done 
if  [  -n "$DIRECTORY" ]; then
   File_W_Adress
else
  File
fi
