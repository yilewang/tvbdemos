with open('/scratch/yxw190015/github/tvbdemos/tvb_slurm/go.txt') as f:
    gc = f.read().splitlines()
f.close()

with open('/scratch/yxw190015/github/tvbdemos/tvb_slurm/group.txt') as f:
    group = f.read().splitlines()
f.close()

with open('/scratch/yxw190015/github/tvbdemos/tvb_slurm/caseid.txt') as f:
    caseid = f.read().splitlines()
f.close()


with open('/scratch/yxw190015/github/tvbdemos/tvb_slurm/jobfile_go', 'w') as f:
    for i in range(74):
        print(f"python sim2go.py --grp '{group[i]}' --caseid '{caseid[i]}' --gc '{gc[i]}' --time '180000'", file=f)

