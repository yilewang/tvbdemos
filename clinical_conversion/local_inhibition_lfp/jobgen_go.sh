#!/usr/bin/bash

# group=$`cat group.txt`
# caseid=$`cat caseid.txt`

while IFS=$' \t\r\n' read -r group && IFS=$' \t\r\n' read -r caseid <&3 && IFS=$' \t\r\n' read -r go <&4;
do
    echo "python go_lfp.py --Group $group --Caseid $caseid --Go $go"  >> jobfile
done < group.txt 3< caseid.txt 4< go.txt
