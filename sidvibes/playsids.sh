#!/bin/bash

IFS=";"

LISTFILE="sidlist.txt"
HVSC_BASE="../C64Music"
export HVSC_BASE
FPOUT="sidplayfp-output.txt"
CNTFILE="sidinfo-counter.txt"

#killall -q projectMSDL
#nohup projectMSDL/projectMSDL.exe &

killall -q EyeTune.WindowsUniversal.Application.exe
#get start command:
# explorer.exe 'shell:appsFolder'
# make desktop shortcut. shortcut target here, after appsfolder\
explorer.exe 'shell:appsFolder\13183Mancoast.EyeTune_k7gtqf3v1rgjm!App'

while [ 1 ]; do
    shuf -n 1 $LISTFILE | while read SID; do
        #echo $SID
        SIDFILE=$HVSC_BASE$SID
        #echo $SIDFILE

        nohup sidplayfp/sidplayfp.exe $SIDFILE --none -v > $FPOUT 2>&1 &
        sleep 1
        killall sidplayfp

        echo $SID > sidinfo-sidfilename.txt
        # cat $FPOUT
        TITLE=$(grep "Title" $FPOUT | sed "s/\| Title        : //g" | sed "s/\r//g" | cut -f 2 -d "|" | head -n1  )
        echo $TITLE > sidinfo-title.txt
        AUTHOR=$(grep "Author" $FPOUT | sed "s/\| Author       : //g" | sed "s/\r//g" | cut -f 2 -d "|" | head -n1  )
        echo $AUTHOR > sidinfo-author.txt
        RELEASED=$(grep "Released" $FPOUT | sed "s/\| Released     : //g" | sed "s/\r//g" | cut -f 2 -d "|" | head -n1  )
        echo $RELEASED > sidinfo-released.txt  
        LENGTHTEXT=$(grep "Song Length" $FPOUT | sed "s/\| Song Length  : //g" | sed "s/\r//g" | cut -f 2 -d "|" | cut -f 1 -d "." | head -n1 )
        echo $LENGTHTEXT > sidinfo-length.txt     
        SPEED=$(grep "Song Speed" $FPOUT | sed "s/\| Song Speed   : //g" | sed "s/\r//g" | cut -f 2 -d "|" | head -n1  )
        echo $SPEED > sidinfo-speed.txt    
        PLAYMODE=$(grep "Play mode" $FPOUT | sed "s/\| Play mode    : //g" | sed "s/\r//g" | cut -f 2 -d "|" | head -n1  )
        echo $PLAYMODE > sidinfo-playmode.txt        
        SIDMODEL=$(grep "SID Details" $FPOUT | sed "s/\| SID Details  : //g" | sed "s/\r//g" | cut -f 2 -d "|" | sed "s/Model = //g" | head -n1  )
        echo $SIDMODEL > sidinfo-sidmodel.txt     

        # calculate length in seconds
        LSTART=$(date  -d"00:00" +%s)
        LEND=$(date -d"$LENGTHTEXT" +%s)
        LENGTHSEC=$(((LEND-LSTART)/60))


        echo "Length : $LENGTHSEC"

        nohup sidplayfp/sidplayfp.exe $SIDFILE -v  2>&1 &

        

        if (( $LENGTHSEC > 120 ));then
            CNT=120
            echo "more than 120"
        else
            CNT=$LENGTHSEC
            echo "less than 120"
        fi


        while [ $CNT -ne 0 ];do
            echo -en $CNT > $CNTFILE
            ((CNT-=1))
            echo -en "\r         \r $CNT"
            sleep 1
        done

        killall sidplayfp

    done
done
