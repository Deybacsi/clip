#!/bin/bash

IFS=";"

#LISTFILE="sidlist.txt"
LISTFILE="sidlist-with-lengths.txt"
HVSC_BASE="../C64Music"
export HVSC_BASE
FPOUT="sidplayfp-output.txt"
CNTFILE="sidinfo-counter.txt"

STREAM_STARTED_EPOCH_FILE="streamstarted.txt"
STREAM_STARTED_EPOCH=0
STREAM_RESTART_AFTER=3600
echo 0 > $STREAM_STARTED_EPOCH_FILE

# windows store eyetune
#killall -q EyeTune.WindowsUniversal.Application.exe
#get start command:
# explorer.exe 'shell:appsFolder'
# make desktop shortcut. shortcut target here, after appsfolder\
#explorer.exe 'shell:appsFolder\13183Mancoast.EyeTune_k7gtqf3v1rgjm!App'

while [ 1 ]; do
    shuf -n 1 $LISTFILE | while read SID LENGTHSEC; do
        echo

        EPOCH_NOW=$(date +%s)
        STREAM_STARTED_EPOCH=$(cat $STREAM_STARTED_EPOCH_FILE)
        echo "Stream running time: " $(( $EPOCH_NOW - $STREAM_STARTED_EPOCH )) "secs"
        if (( $EPOCH_NOW - $STREAM_STARTED_EPOCH > $STREAM_RESTART_AFTER ));then
            echo $EPOCH_NOW > $STREAM_STARTED_EPOCH_FILE
            echo "---- Restarting stream ----"
            echo "Stop stream:"
            ../OBSCommand/OBSCommand.exe /stopstream
            sleep 5
            echo "Start stream:"
            ../OBSCommand/OBSCommand.exe /startstream
        fi
        export STREAM_STARTED_EPOCH
        echo $STREAM_STARTED_EPOCH

        SIDFILE=$HVSC_BASE$SID
        echo $SIDFILE
        echo "Length : $LENGTHSEC"    
        if (( $LENGTHSEC < 60 ));then
            echo "ASDSAD";
            continue;
        fi

        if (( $(ps -ef | grep projectMSDL | wc -l) < 1 )); then
            # local projectM/eyetune
            killall -q projectMSDL
            nohup projectMSDL-Windows-x64-2.0-pre2/projectMSDL.exe >/dev/null &
        fi

        nohup sidplayfp/sidplayfp.exe $SIDFILE --none -v > $FPOUT 2>&1 && killall -q sidplayfp

        echo $SID > sidinfo-sidfilename.txt
        # cat $FPOUT
        TITLE=$(grep "Title" $FPOUT | sed "s/\| Title        : //g" | sed "s/\r//g" | cut -f 2 -d "|" | head -n1  )
        echo $TITLE > sidinfo-title.txt
        echo $TITLE
        AUTHOR=$(grep "Author" $FPOUT | sed "s/\| Author       : //g" | sed "s/\r//g" | cut -f 2 -d "|" | head -n1  )
        echo $AUTHOR > sidinfo-author.txt
        echo $AUTHOR
        RELEASED=$(grep "Released" $FPOUT | sed "s/\| Released     : //g" | sed "s/\r//g" | cut -f 2 -d "|" | head -n1  )
        echo $RELEASED > sidinfo-released.txt  
        echo $RELEASED
        LENGTHTEXT=$(grep "Song Length" $FPOUT | sed "s/\| Song Length  : //g" | sed "s/\r//g" | cut -f 2 -d "|" | cut -f 1 -d "." | head -n1 )
        echo $LENGTHTEXT > sidinfo-length.txt     
        echo $LENGTHTEXT
        
        #SPEED=$(grep "Song Speed" $FPOUT | sed "s/\| Song Speed   : //g" | sed "s/\r//g" | cut -f 2 -d "|" | head -n1  )
        #echo $SPEED > sidinfo-speed.txt    
        #echo $SPEED
        #PLAYMODE=$(grep "Play mode" $FPOUT | sed "s/\| Play mode    : //g" | sed "s/\r//g" | cut -f 2 -d "|" | head -n1  )
        #echo $PLAYMODE > sidinfo-playmode.txt        
        #echo $PLAYMODE
        #SIDMODEL=$(grep "SID Details" $FPOUT | sed "s/\| SID Details  : //g" | sed "s/\r//g" | cut -f 2 -d "|" | sed "s/Model = //g" | head -n1  )
        #echo $SIDMODEL > sidinfo-sidmodel.txt     
        #echo $SIDMODEL

        nohup sidplayfp/sidplayfp.exe $SIDFILE -v >/dev/null 2>&1 &

        if (( $LENGTHSEC > 240 ));then
            CNT=240
            echo "more than 240"
        else
            CNT=$LENGTHSEC
            echo "less than 240"
        fi

        while [ $CNT -ge 1 ];do
            echo -en $CNT > $CNTFILE
            ((CNT-=1))
            echo -en "\r         \r $CNT"
            sleep 1
        done

        killall -q sidplayfp

    done
done
