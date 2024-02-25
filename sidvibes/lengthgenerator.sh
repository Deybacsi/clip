#!/bin/bash
#
# run as 
#
# ./lengthgenerator.sh | tee sidlist-with-lengths.txt
#
IFS=""
TZ=utc

HVSC_BASE="../C64Music"
LENGTHFILE=$HVSC_BASE"/DOCUMENTS/Songlengths.md5"

#grep ".sid" $LENGTHFILE | wc -l

cat $LENGTHFILE | while read L; do

    if [[ $L =~ ^\;.* ]]; then
       echo -en $L | sed 's/\; //g' | sed 's/\r//g'
    fi
    if [[ $L =~ ^.*\=.* ]]; then
        echo -en ";"
        LENGTHTEXT=$(echo -en $L | cut -d"=" -f 2 | cut -d" " -f 1 | cut -d"." -f 1)
        #echo -en "\n"
        #echo $LENGTHTEXT
        LENGTHSEC=$(date -d "1970-01-01 00:$LENGTHTEXT" +%s)
        # add + 1 hour if not utc ;)
        ((LENGTHSEC=$LENGTHSEC+3600))
        echo $LENGTHSEC
    fi
done
