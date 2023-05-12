#!/usr/bin/bash

# group=$`cat group.txt`
# caseid=$`cat caseid.txt`

while IFS=$' \t\r\n' read -r group && IFS=$' \t\r\n' read -r caseid <&3;
do
    for j in $(seq 0.01 0.01 0.07);
    do
        echo -e "python global_coupling_fitting.py --Group $group --Caseid $caseid --G $j" >> jobfile
    done
done < group.txt 3< caseid.txt

