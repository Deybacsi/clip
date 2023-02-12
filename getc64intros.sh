#!/bin/bash

# populates a list.txt file in intros/C64 that contains a group name and a filename
# it only gets the first 10 filenames for each group !!!!
# running of
#     fixlist.sh 
# is needed after this script to make the final intro list

# download the full intro pack zip from intros.c64.org, extract it to intros/C64 folder
 

IFS=''

MYTMP="./temp"

rm $MYTMP/gtemp.txt
rm $MYTMP/g2temp.txt
> $MYTMP/list.txt
> intros/C64/list.txt

#for LETTER in 0 ; do
for LETTER in 0 {A..Z}; do
    echo $LETTER

    #GROUPS=$(curl -k https://index.hu)

    curl -s -k https://intros.c64.org/frame.php?letter=$LETTER | grep "module=showintros&group=" > $MYTMP/gtemp.txt

    cat $MYTMP/gtemp.txt | while read GROUP; do
        LINK=$(echo $GROUP | cut -d '"' -f 2)
        NAME=$(echo $GROUP | cut -d '>' -f 2 | cut -d '<' -f 1)
        #echo $LINK
        if [[ "$NAME" =~ ", The" ]]; then
            NAME=$(echo $NAME | sed 's/, The//g')
            NAME="The $NAME"
        fi
        echo 
        echo "Group: $NAME"
        sleep 1
        curl -s -k https://intros.c64.org/$LINK | grep "module=showintro&iid=" > $MYTMP/g2temp.txt
        cat $MYTMP/g2temp.txt | while read INTRO; do
            FILE=$(echo $INTRO | cut -d "'" -f2 | sed 's/\/intro\///g')
            echo "      Intro: $FILE"
            #echo $INTRO

            echo "$NAME;$FILE" >> $MYTMP/list.txt
        done

    done

done

echo "Sorting final list"
cat $MYTMP/list.txt | sort -u > intros/C64/list.txt

echo "All done!"


# https://www.lemon64.com/forum/viewtopic.php?t=55750&sid=90ce8080e4a1abfae02e1b4d4e788144



