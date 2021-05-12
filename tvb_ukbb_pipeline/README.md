# Steps to install tvb-ukbb pipeline into the europa

### 1. login to the europa

you should have your account (netid) and password.

### 2. use specific tar file to install the pipeline

the tar file is located at `/opt/ohpc/pub/groups/tvb`. The command you will use is

```bash
tar xf /opt/ohpc/pub/groups/tvb/tvb-pipeline_installer_1.1-europa.tar.gz

```

then you will see a folder named tvb-pipeline in your $HOME directory.

### 3. run the install_csim.sh

In tvb-pipeline directory, all you need to do is to run the specific version of the pipeline:

```bash
sh install_csim.sh
```

Then you should have tvb-ukbb pipeline in your europa account

### 4. How to use it?

well, it is a little more complex question compared to how to install it. 

first, you need to source the `init_vars` file to activate the environment

```bash
cd
cd tvb-pipeline/tvb-ukbb
source init_vars
```

After that, you need to create a specific data dir in your $HOME dir

```bash
cd 
mkdir data #or any name you want
```

the data dir will be the place to put in the HSAM folder (the folder contains T1.nii.gz)

Then, in the data dir, you should copy a slurm file, which is designed to submit the job to the compute nodes

```bash 
cd
cd data
cp /opt/ohpc/pub/groups/tvb/tvb-ukbb.slurm .
```

then you will have a slurm file in your data dir. Let's take a look at the slurm file

```bash
vim tvb-ukbb.slurm
```

In the slurm file, you can see a line of command
```bash
time python $HOME/tvb-pipeline/tvb-ukbb/bb_pipeline_tools/bb_pipeline.py HSAM_1
```
All we need to change is the `HSAM_1` part. If you have different data folder name, you should change it.

The way you can change things in vim, is to enter `i`, and then change. If you want to save and quit the vim, type `esc` and type `:wq` then you will see your europa interface again.

after finish all the procedures above, you can try to submit your job to the europa now:

```bash
sbatch tvb-ukbb.slurm
```

It will cost around 30 mins (I guess?). you can leave it alone and check back later.

Then, check back your HSAM_1 folder, you should see T1 folder has everything you want.

## A WARNING:

This method is only just for submiting ONE JOB per time. Once you suceed, we can move on to try to submit jobs with `launcher`, which will let you submit your job in parallel.

## Additional info:
The recording of the tvb-ukbb pipeline installation, by Dr. Simmons. [link](https://web.microsoftstream.com/video/ac4b679d-5274-45ff-b481-b3707bd06350?list=user&userId=d1cb665c-d52f-4abb-808f-72eaaa4a451e)
