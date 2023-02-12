#!/bin/bash

CNT=120
CNTFILE="intros/C64/counter.txt"

while [ $CNT -ne 0 ];do
    echo -en "Next in\n"$CNT > $CNTFILE
    ((CNT-=1))
    echo $CNT
    sleep 1
done
> $CNTFILE
./nircmd.exe win activate ititle "OBS" && sleep 1
killall x64sc
