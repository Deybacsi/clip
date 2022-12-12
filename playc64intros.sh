#!/bin/bash

# put the vice c64 exe path here
EMUEXE="C:\GTK3VICE-3.6.1-win64\bin\x64sc.exe"
# if it's not installed on C: then  change c: and C: to the right drive letter in the below line
EMUEXE=$(echo $EMUEXE | sed 's/\\/\//g' | sed 's/c:/\/drives\/C/g' | sed 's/C:/\/drives\/C/g' )


echo $EMUEXE

LOGFILE="log-playc64intros.txt"


IFS=";"

while [ 1 ]; do
    shuf -n 1 intros/C64/list.txt | while read GROUP INTRO; do
        echo -en "\n\n\n\nSearching for $GROUP - $INTRO ..."
        INTROFILE=$(find intros/ -name "$INTRO.prg")
        if [[ -f "$INTROFILE" ]]; then
            echo -en "found $INTROFILE\n"
            echo "Loading"
            $EMUEXE $INTROFILE
        else
            
            echo -en "$INTRO.prg not found!\n"
            echo "$INTRO.prg not found" >> $LOGFILE        
        fi
    done
done
