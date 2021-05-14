

## Jobs submission via launcher in UT Dallas Europa system


The launcher website: [link](https://github.com/TACC/)


I will introduce a basic method of how to use launcher to submit parallel jobs into the europa. I will use an easy example to illustrate the process. 


The most straightforward example is the for loop: When we are writing python script, for loop is the most basic syntax we need to know. By using for loop, we can iterate value automatically into our computation. Launcher can help us doing for loop in he HPC system so that we can submit jobs into different cores and run it in parallel way. 



Let's say we have a simple case now:

Generally, if we want to calculate something iteratively, we may want to use script below:

```python
A = [2, 3, 4, 5, 6]

def test(i):
	return i*2

for i in A:
	print('My magic number is: ', str(test(i)))


``` 

A for loop will help us handle everything. However, all the computations are running sequentially, instead of in parallel. In order to use the power of the HPC (multi-threads), we need to use a new format to submit our jobs.


Therefore, we need a new scripting way to make launcher understand the iteration. Python script used for launcher will be:(script name: test.py)

```python
import sys

i = sys.argv[1]

def test(i):
	return i*2

print('My magic number is: ', str(test(i)) 


```
In this script, the i is replaced by the argument from bash (we use bash to evoke the script). The way we evoke the script by jobfile would be: 

```bash
python test.py 2
python test.py 3
python test.py 4
python test.py 5
python test.py 6

```
From here we can see, instead of using for loop, in launcher, we need to break the loop into individual job. By using bash scripting, we can create jobfile with high efficiency.

```bash 
#!/bin/bash

for i in $(seq 2 6)
do
	seq -f "python test.py $i" >> jobfile
done
```



if we look at the result, we will find out that the output is as same as the commandlines we used to evoke the script. This is the jobfile we need for running parallel jobs.


The last part is to have a slurm script. Slurm script is used to configure the computational resource for your jobs. The template is attached below for personalization:

Let's call it test.slurm

```bash

#!/bin/bash



# simple SLURM script for submitting jobs.


#----------------------------------------




# setup parameters

#SBATCH -J launcher
#SBATCH -N 1
#SBTAHC -n 16
#SBATCH -p normal
#SBATCH -o job.%j.out
#SBATCH -e job.%j.err
#SBTACH -t 2-00:00:00


module load launcher

export LD_LIBRARY_PATH=/lib64:$LD_LIBRARY_PATH
export LAUNCHER_WORKDIR=$HOME/workdir
export LAUNCHER_JOB_FILE=jobfile

$LAUNCHER_DIR/paramrun


```

We can change `-N` and `-n` as the number of nodes we want and total jobs we run. `-o` and `-e` will be the output and the error output. `-t` is the time you request from the system. 

LAUNCHER_WORDIR is the folder path you store your scripts and jobfile.

By typing `sbatch test.slurm`, you can submit the tasks to the HPC system. 


`watch -n 1 squeue -u$USER` can help me to check the progress of my job.


















