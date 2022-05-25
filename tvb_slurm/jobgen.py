with open('/scratch/nkk170000/tvbdemos/tvb_slurm/Go.txt') as f:
    gc = f.read().splitlines()
f.close()

with open('/scratch/nkk170000/tvbdemos/tvb_slurm/group.txt') as f:
    group = f.read().splitlines()
f.close()

with open('/scratch/nkk170000/tvbdemos/tvb_slurm/caseid.txt') as f:
    caseid = f.read().splitlines()
f.close()


with open('/scratch/nkk170000/tvbdemos/tvb_slurm/jobfile', 'w') as f:
    for i in range(74):
        print(f"python sim2hdf5.py --grp '{group[i]}' --caseid '{caseid[i]}' --gc '{gc[i]}' --time '180000'", file=f)
