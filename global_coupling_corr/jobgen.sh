#!/usr/bin/bash

# group=$`cat group.txt`
# caseid=$`cat caseid.txt`

while IFS=$' \t\r\n' read -r group && IFS= read -r caseid <&3;
do
    for j in $(seq 0.01 0.001 0.07);
    do
        echo -e "python --G $j --Group $group --Caseid $caseid" >> jobfile
    done
done < group.txt 3< caseid.txt

