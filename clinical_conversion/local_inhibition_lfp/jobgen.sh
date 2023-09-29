#!/usr/bin/bash

# group=$`cat group.txt`
# caseid=$`cat caseid.txt`

while IFS=$' \t\r\n' read -r group && IFS=$' \t\r\n' read -r caseid <&3 && IFS=$' \t\r\n' read -r gc <&4 && IFS=$' \t\r\n' read -r K21 <&5;
do
    echo "python K21_lfp.py --Group $group --Caseid $caseid --Gc $gc --K21 $K21"  >> jobfile
done < group.txt 3< caseid.txt 4< gc.txt 5< K21.txt
