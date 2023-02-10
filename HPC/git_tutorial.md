# Github Workflow Tutorial
## Git Overview

How to properly use github to manage and share your codes is always an essential thing we need to learn before we start our project. In this tutorial, I will introduce a simple workflow that you can use for doing version control to your code, and properly collaborating with others in an open source project.

#### What's git?
Git is a tool used for **tracking changes**. Imagining you are using Microsoft Words, and the Words always tracks what you type and delete, and helps you save your work. Git does the same things but for your codes.

## Git: Single Player Mode

In order to know how to use Git, let's just start with an easy example.

Currently I am working in an Alzheimer's Disease project, and I have a repository in github called `repo_name` (I skipped the processes to create your github account and create new repository, since they are straightforward).

### How to set up Git?

#### Step 1 generate ssh key

```bash
ssh-keygen -t rsa -b 4096
```

#### Step 2 add the public key into your github account

```bash 
cd $HOME/.ssh && cat id_rsa.pub
```

#### Step 3 clone the repository into your local disk

```bash
git clone git@github.com:user_name/repo_name.git
```

Then you can access your github repository in your local terminal.

### How to do version control with Git?

#### Step 1 pull the repo

The reason why we need to pull the repo before we change anything is to avoid conflict

```bash
git pull
```

#### Step 2 add files

```bash
git add YOUR_FILE
```
or you want to track multiple files
```bash
git add .
```
#### Step 3 leave comments for your changes

```bash
git commit -m "YOUR_COMMENTS"
```
#### Step 4 push your changes

```bash
git push
```


## Git: Multi-Player Mode

When you are working in a group project, your workflow to interact with Git will be slightly different than working alone. The main reason is that you need to make sure you don't destory the project by your accidental operations. One important thing is to use `branch` when you want to contribute to a group project

### Make local changes

#### Step 1 clone repo and create new branch

In order to be coherent and continuous, I will start with cloning the same repo here:

```bash
git clone git@github.com:user_name/repo_name.git
git checkout -b my-new-branch
```

#### Step 2 save your work in your new branch

```bash
git add .
git commit -m "YOUR_COMMENTS"
```

#### Step 3 push to new branch

```bash
git push origin my-new-branch
```

**WHAT IF SOMEONE SUBMIT A NEW UPDATE AHEAD OF ME???**

When we are doing collaboration, it is super usual that you and other people are working with the same project but different parts. Sometimes when you just finish your part of codes and you want to update it into the main branch, however, you notice that a new update from other people is already there. One thing you need to do is to test if the new update could be merged into your update.

#### *Step 1 update local main branch

```bash
git checkout main
git pull origin master # pull the new update from others to your local main
```

#### *Step 2 rebase the local branch

The rebase step can help us to add our new changes to updated main branch

```bash
git checkout my-new-branch
git rebase main # It is an important step!!! rebase will add your changes to the updated main so that you can know if your codes are compatible with the new updates from others
```
#### *Step 3 push

```bash
git push origin my-new-branch
```


#### Step 4 create new pull request

you need to do it in github website


## Useful commands

```bash 
git diff # check the differences between repo and repo in your disk
git branch -D my-new-branch # delete branch
git status # check the current status of your repo
git stash # be careful! but this command can help you discard all your changes
```