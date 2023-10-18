#!/usr/bin/bash

# group=$`cat group.txt`
# caseid=$`cat caseid.txt`

while IFS=$' \t\r\n' read -r group && IFS=$' \t\r\n' read -r caseid <&3 && IFS=$' \t\r\n' read -r gc <&4;
do
    echo "python gc_lfp.py --Group $group --Caseid $caseid --Gc $gc"  >> jobfile
done < group.txt 3< caseid.txt 4< gc.txt
