with open('C:/Users/wayne/Desktop/Gc.txt') as f:
    gc = f.read().splitlines()
f.close()

with open('C:/Users/wayne/Desktop/group.txt') as f:
    group = f.read().splitlines()
f.close()

with open('C:/Users/wayne/Desktop/caseid.txt') as f:
    caseid = f.read().splitlines()
f.close()


with open('C:/Users/wayne/Desktop/res.txt', 'w') as f:
    for i in range(73):
        print(f"python sim2.py {group[i]} {caseid[i]} {gc[i]} 180000", file=f)
