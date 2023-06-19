#!/bin/bash


# client_secret.apps.googleusercontent.com.json

# https://tanaikech.github.io/2022/11/11/curl-command-uploading-video-file-to-youtube-with-resumable-upload-using-youtube-api/

VIDEOFOLDER="../../Videók" # there are hardcoded shit also below
SAVEDVIDEOSFILE="$VIDEOFOLDER/completevideos/videos.txt"

LOGFILE="log-uploader.txt"

IFS=";"


#while [ 1 ]; do
    shuf -n 1 $SAVEDVIDEOSFILE | while read INTRO LINK; do
        CURTIME=$(date '+%Y.%m.%d %H:%M')
        # if video is not uploaded
        if [[ "$LINK" == "" ]]; then
            GROUP=$(grep $INTRO intros/C64/list-final.txt | cut -d";" -f 1)
            echo $CURTIME "---------------------------------------------------------------------"
            echo $INTRO - $GROUP - $LINK
            VIDEOFILE="$VIDEOFOLDER/completevideos/$INTRO.mkv"
            ls -la $VIDEOFILE

            read -r -d '' DESCRIPTION <<-EOF
C64 cracktro $INTRO by $GROUP 

Download the original intro .prg file: https://intros.c64.org/intro/$INTRO 

24/7 live streams:
Twitch: https://www.twitch.tv/c64intros
Youtube: https://www.youtube.com/@c64intros/streams

Community:
Discord: https://discord.gg/Zh9FFH6ZRv 
Facebook: https://www.facebook.com/c64intros

Support my work, buy me a cofee: https://streamlabs.com/c64intros/tip 

Cracktros in your browser: https://www.c64intros.com

What is a cracktro? https://en.wikipedia.org/wiki/Crack_intro

If there is no sound, don't panic. Not every intro contains music. This is especially true for intros created before 1990.

This channel is entirely based on automated uploads, with the videos being separate recordings from the C64intros live Twitch channel. If you notice any errors or issues, please contact me at:
c64intros@gmail.com
The recordings were made with VICE emulator on PC, not on original hardware, so the movement of objects on the screen and scrolling may not be smooth. This is a technical limitation of emulators and the fact that our modern flat displays do not operate at 50Hz anymore.
This YouTube channel is in no way affiliated with intros.c64.org; it simply utilizes the freely available and downloadable intros on the website.
EOF
                       



            RESPONSE=$(python upload_video.py --file="$VIDEOFILE" \
                        --title="$INTRO - $GROUP | C64 cracker intros 24/7"\
                        --description="$DESCRIPTION"\
                        --keywords="c64,commodore 64,commodore64,cracker intro,cracktro,demoscene,retro,c-64,c 64,demo,intro,8bit,8 bit,8-bit,commodore,comodore,chiptune,sid,sid chip,hvsc,80's,90's,1990,1980"\
                        --category="28"\
                        --privacyStatus="public")
            echo $RESPONSE | tee -a $LOGFILE


#Uploading file...
#eF3P7i3DaEw was successfully uploaded.


        fi

    done

#done