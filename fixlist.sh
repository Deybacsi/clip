#!/bin/bash

# first run getc64intros.sh
# then unzip the all intro pack to intros/C64
# then run this 

PRGPATH="intros/C64/intros_c64_org_11234_full"
LISTPATH="intros/C64/"
FINALLIST="$LISTPATH/list-final.txt"
> $FINALLIST

GROUPNAME="" 
INTRONAME=""
IFS=";"

rm groupname.tmp
 
ls -1 $PRGPATH | while read PRG
do
    INTRO=$(echo $PRG | sed 's/.prg//g')
    echo -en $INTRO"-"
    LASTGROUP=$GROUPNAME
    grep ";$INTRO" $LISTPATH/list.txt | (
        while read GROUPNAME INTRONAME; do
            #echo -en "\t $GROUPNAME $INTRONAME"
            echo -en "$GROUPNAME" > groupname.tmp
            echo -en "OK"
        done 

        GROUPNAME=$(cat groupname.tmp)
        #if [ -z $GROUPNAME ]; then
        #    GROUPNAME=$LASTGROUP
        #    echo -en "FIX"
        #fi

        echo -en "\t\t$GROUPNAME;$INTRO"
        echo -en "$GROUPNAME;$INTRO;" >> $FINALLIST

        #YEAREST=$(grep -aohE "[0-9]{1,4}\.[0-9]{1,2}\.[0-9]{1,4}|[0-9]{1,4}\/[0-9]{1,2}\/[0-9]{1,4}|[0-9]{1,4}\-[0-9]{1,2}\-[0-9]{1,4}|\ [0-9]{4}\ " $PRGPATH/$PRG | head -n 1)

        #YEAREST=$(echo $YEAREST | sed 's/ //g')     # split spaces
        #if [ "${#YEAREST}" -eq 4 ]; then # string = "YYYY"
        #    if [ $YEAREST -lt 1982 ] || [ $YEAREST -gt 2020 ]; then
        #        YEAREST=""
        #    fi
        #fi

        #if [ -n $YEAREST ]; then 
        #    echo -en "\t$YEAREST"
        #fi
        #echo -en "$YEAREST;" >> $FINALLIST
        #echo -en "\n"

        echo -en "\n" >> $FINALLIST

    )

    #OK=$(grep $INTRO $LISTPATH/list.txt | wc -l)
    #if [[ $OK > 0 ]];then
    #    echo -en $OK"\n"
    #fi
    #echo -en $OK"\n"
done

rm groupname.tmp
