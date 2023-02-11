#!/bin/bash

# put the vice c64 exe path here
#relative path
EMUEXE="emulators\vice\GTK3VICE-3.6.1-win64\bin\x64sc.exe"

# absolute path
#EMUEXE="C:\GTK3VICE-3.6.1-win64\bin\x64sc.exe"
# if it's not installed on C: then  change c: and C: to the right drive letter in the below line
EMUEXE=$(echo $EMUEXE | sed 's/\\/\//g' | sed 's/c:/\/drives\/C/g' | sed 's/C:/\/drives\/C/g' )
echo $EMUEXE > emuexe.sh


echo $EMUEXE

LOGFILE="log-playc64intros.txt"
INFOFILE="intros/C64/nowplaying.txt"
LATESTFILE="intros/C64/latest.txt"
MYPATH=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
echo $MYPATH


IFS=";"


while [ 1 ]; do
    shuf -n 1 intros/C64/list.txt | while read GROUP INTRO; do
        echo -en "\n\n\n\nSearching for $GROUP - $INTRO ..."
        #echo "SEARCHING FOR $INTRO" > $INFOFILE
        #echo "LOADING" >> $INFOFILE
        #INTROFILE=$(find intros/ -name "$INTRO.prg")
        INTROFILE="intros/C64/intros_c64_org_11234_full/$INTRO.prg"
        echo $INTROFILE
        if [[ -f "$INTROFILE" ]]; then
            echo -en "found $INTROFILE\n"
            echo "Loading"
            echo "$GROUP: $INTRO" > $INFOFILE
            echo "$GROUP: $INTRO" >> $LATESTFILE
            echo "$(tail -5 $LATESTFILE)" > $LATESTFILE 
            #echo "intros.c64.org/intro/$INTRO" >> $INFOFILE
            nohup $MYPATH/emukiller.sh &
            $EMUEXE $INTROFILE
            sleep 3
        else
            echo -en "$INTRO.prg not found!\n"
            echo "$INTRO.prg not found" >> $LOGFILE        
        fi
    done
done
