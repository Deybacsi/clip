#!/bin/bash

# video uploader script v1.0

VIDEOFOLDER="../../Videók" 
SAVEDVIDEOSFILE="$VIDEOFOLDER/completevideos/videos.txt"

LOGFILE="log-uploader.txt"

IFS=";"

# sleep 900 sec = 15 min
CNT=900


while [ 1 ]; do
    # get one intro from the saved videos list
    grep -v "https://youtu.be/" $SAVEDVIDEOSFILE | head -n1 | while read INTRO LINK; do
        CURTIME=$(date '+%Y.%m.%d %H:%M')
        # if video is not uploaded
        if [[ "$LINK" == "" ]]; then
            # get the group name
            GROUP=$(grep ";$INTRO;" intros/C64/list-final.txt | cut -d";" -f 1)
            echo $CURTIME "---------------------------------------------------------------------"
            echo "Intro: $INTRO - $GROUP - $LINK"
            echo "Videofile:"
            VIDEOFILE="$VIDEOFOLDER/completevideos/$INTRO.mkv" # videofile to upload
            ls -la $VIDEOFILE

            read -r -d '' DESCRIPTION <<-EOF        
#C64 #crack #intro $INTRO by $GROUP 

Download the original intro .prg file: https://intros.c64.org/intro/$INTRO 

24/7 live streams:
Twitch: https://www.twitch.tv/c64intros
Youtube: https://www.youtube.com/@c64intros/live

Community:
Discord: https://discord.gg/Zh9FFH6ZRv 
Facebook: https://www.facebook.com/c64intros

You can support my work, and buy me a cofee: https://streamlabs.com/c64intros/tip 

Crack intros in your browser: https://www.c64intros.com

What is a cracktro? https://en.wikipedia.org/wiki/Crack_intro

If there is no sound, don't panic. Not every intro contains music. This is especially true for intros created before 1990.

This channel is entirely based on automated uploads, with the videos being separate recordings from the C64intros live Twitch channel. 
The recordings were made with #VICE #emulator on PC, not on original hardware, so the movement of objects on the screen and scrolling may not be smooth. This is a technical limitation of emulators and the fact that our modern flat displays do not operate at 50Hz anymore.
This YouTube channel is in no way affiliated with intros.c64.org; it simply utilizes the freely available and downloadable intros on the website.

If you notice any errors or issues, please contact me at:
c64intros@gmail.com

READY.
█

EOF
                       


            # upload video to YT

            RESPONSE=$(python upload_video.py --file="$VIDEOFILE" \
                        --title="$INTRO - $GROUP | C64 crack intros 24/7"\
                        --description="$DESCRIPTION"\
                        --keywords="c64,commodore 64,commodore64,cracker intro,cracktro,demoscene,retro,c-64,c 64,demo,intro,8bit,8 bit,8-bit,commodore,comodore,chiptune,sid,sid chip,hvsc,80's,90's,1990,1980"\
                        --category="28"\
                        --privacyStatus="public")

            # put response to log
            echo "$CURTIME: $INTRO - $RESPONSE" | tee -a $LOGFILE

            # upload was successful?
            if (( $(echo $RESPONSE | grep 'was successfully uploaded' | wc -l ) == 1 ));then
                VIDEOLINK=$(echo $RESPONSE | grep 'was successfully uploaded' | cut -d" " -f 1)
                sed -i "s/^$INTRO;/$INTRO;https:\/\/youtu.be\/$VIDEOLINK/" $SAVEDVIDEOSFILE
                rm $VIDEOFILE
                echo "$VIDEOFILE removed" >> $LOGFILE
            fi

        fi
    done

    echo "Sleeping..."
    while [ $CNT -ne 0 ];do
        ((CNT-=1))
        echo -en "\r         \r $CNT"
        sleep 1
    done    
    CNT=900
    echo
done


#Uploading file...
#eF3P7i3DaEw was successfully uploaded.