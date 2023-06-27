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
if [[ "$1" == "test" ]]; then
    CNT=20
    SAVEDVIDEOS=25
elif [[ "$1" == "live" ]]; then
    CNT=120
    SAVEDVIDEOS=500
else 
    exit
fi


echo $CNT
echo $SAVEDVIDEOS



CNTFILE="intros/C64/counter.txt"
LOGFILE="log-playc64intros.txt"
INFOFILE="intros/C64/nowplaying.txt"
LATESTFILE="intros/C64/latest.txt"
YEARFILE="intros/C64/yearestimator.txt"

VIDEOFOLDER="../../Videók" # there are hardcoded shit also below

SAVEDVIDEOSFILE="$VIDEOFOLDER/completevideos/videos.txt"


MYPATH=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
echo $MYPATH

> $LOGFILE
> $CNTFILE
> $INFOFILE
 
IFS=";"

while [ 1 ]; do
    shuf -n 1 intros/C64/list-final.txt | while read GROUP INTRO YEAR; do

        echo -en "\n\n\n\nSearching for $GROUP - $INTRO ..."
        #echo "SEARCHING FOR $INTRO" > $INFOFILE
        #echo "LOADING" >> $INFOFILE
        #INTROFILE=$(find intros/ -name "$INTRO.prg")
        INTROFILE="intros/C64/intros_c64_org_11234_full/$INTRO.prg"
        echo $INTROFILE
        if [[ -f "$INTROFILE" ]]; then
            OBSCommand/OBSCommand.exe /stoprecording
            echo -en "found $INTROFILE\n"
            echo "Loading"
            echo "$INTRO / $GROUP" > $INFOFILE
            echo "$INTRO / $GROUP" >> $LATESTFILE
            echo "$(tail -5 $LATESTFILE)" > $LATESTFILE 
            echo -en "$YEAR" > $YEARFILE
            #echo "intros.c64.org/intro/$INTRO" >> $INFOFILE
            #kill -9 $(cat emukiller_pid.txt)                                               # kill stucked emukillers to avoid <2min kills
            #nohup $MYPATH/emukiller.sh &
            #echo $! > emukiller_pid.txt

            #echo "$(ls -l '../../Videók/completevideos/' | wc -l)"
            #echo "$( grep -v $INTRO $SAVEDVIDEOSFILE | wc -l)" &&exit



            echo "No of already saved videos:"
            ls -l '../../Videók/completevideos/' | wc -l
            echo "Max videos : $SAVEDVIDEOS"
            if (( "$(ls -l '../../Videók/completevideos/' | wc -l)" < "$SAVEDVIDEOS" )); then   # check no of saved videos
                if [[ "$( grep $INTRO $SAVEDVIDEOSFILE | wc -l)" < "1" ]]; then                 # & check if video was saved in the past?
                    echo "Start recording"
                    OBSCommand/OBSCommand.exe /startrecording
                fi
            fi        
            STARTTIME=$(date '+%Y-%m-%d?%H-%M')
            echo "Recording start time: $STARTTIME"
            
            echo "Starting VICE:"
            $EMUEXE -silent -remotemonitor c64intros2.prg &          
               
            OBSCommand/OBSCommand /scene=Emulator

  


            sleep 4
            echo "autostart \"$INTROFILE\"" | nc localhost 6510

            while [ $CNT -ne 0 ];do
                echo -en "Next in\n"$CNT > $CNTFILE
                ((CNT-=1))
                echo -en "\r         \r $CNT"
                sleep 1
            done
            echo
            > $CNTFILE
            > $INFOFILE
            OBSCommand/OBSCommand.exe /scene=Wallpapers
            #sleep 1
            OBSCommand/OBSCommand.exe /stoprecording 

            echo "quit" | nc localhost 6510
 
            echo "------------------------------------------------------------------------------------------------------"
            VIDEONAME=$(ls -1t $VIDEOFOLDER/$STARTTIME*.mkv | head -n1)
            echo "!!!!!!!!!!!!!!!!!!!!!!!!!! ------------------------------------ $VIDEONAME"

            echo "Videoname: $VIDEONAME" | tee -a $LOGFILE
            echo "Introname: $INTRO" | tee -a $LOGFILE
            
            mv "$VIDEONAME" "$VIDEOFOLDER/completevideos/$INTRO.mkv" && echo "$INTRO;" >> $SAVEDVIDEOSFILE && echo "---------- MOVED !!! SAVED !!!!--------" >> $LOGFILE
            echo "mv" "$VIDEOFOLDER/$STARTTIME*.mkv" "$VIDEOFOLDER/completevideos/$INTRO.mkv"
            echo "Video moved"
            echo "------------------------------------------------------------------------------------------------------"
            #sleep 1
        else
            echo -en "$INTRO.prg not found!\n"
            echo "$INTRO.prg not found" >> $LOGFILE        
        fi
    done
done
