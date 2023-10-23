#!/usr/bin/bash

# group=$`cat group.txt`
# caseid=$`cat caseid.txt`

while IFS=$' \t\r\n' read -r group && IFS=$' \t\r\n' read -r caseid <&3 && IFS=$' \t\r\n' read -r go <&4;
do
    for j in $(seq 0.4 0.01 0.5);
    do
        echo "python K21_fitting.py --Group $group --Caseid $caseid --Go $go --K21 $j"  >> jobfile
    done
done < group.txt 3< caseid.txt 4< go.txt
