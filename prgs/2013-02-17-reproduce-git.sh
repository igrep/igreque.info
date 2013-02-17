#!/usr/bin/bashdb
# GistID: 4971264

######################################################
# NOTES:
# This is not just an executable shell script.
# You can read this as a blog post also.
# And by excuting, you'll find what I experienced.

# I recommend you to execute this script step by step
# thorough [bashdb](http://bashdb.sourceforge.net/)
# so that you can see what's going on while executing.
# bashdb 2013-02-17-reproduce-git.sh
# or, just execute itself
# chmod +x 2013-02-17-reproduce-git.sh
# ./2013-02-17-reproduce-git.sh
######################################################

# Watch out your current branch before git-pull!
# ==============================================

# Today, let me write about a mistake I made by git-pull.
# You can reproduce the problem by executing this script step by step.
# First, about my environment. Compare with yours.
git_version="git version 1.7.9.5"
echo $git_version
git --version

## Prepare Git repositories to reproduce my failures.
## --------------------------------------------------

# prefix=/path/as/you/like
prefix=`pwd`/reproduce-git
remote_repo=$prefix/remote
my_repo=$prefix/mine
colleague_repo=$prefix/colleague


echo WARNING: I\'m gonna mkdir "$remote_repo".
echo And create some little repositories in that.
echo If you wanna avoid it, enter q to exit.

## create pseudo remote repository
## -------------------------------
mkdir -p $remote_repo
cd $remote_repo
git init --bare

## clone the repository into locals
## -------------------------------

### Do you know that we can clone a local repository as if it were remote?
git clone $remote_repo $my_repo
git clone $remote_repo $colleague_repo

## I created a branch for my job.
## -------------------------------
cd $my_repo
git checkout -b new-feature
echo "loop { puts 'This is Wrong!' }" > some-of-new-feature.rb
git add some-of-new-feature.rb
git commit -m"Add some-of-new-feature.rb"

## On the other hand, one of my colleagues done his job.
## -------------------------------------------------
cd $colleague_repo
### Of course he wrote the code on the other branch for the feature. Not master.
### Then, the branch got merged into master.
echo 'def perfect_code; end' > complete-feature.rb
git add complete-feature.rb
git commit -m"Implement the feature"
git push origin master

## I wanted to save the change my colleague made before on my repository.
## ------------------------------------------------------------
cd $my_repo
git branch # => I was on the *new-feature* branch.
### The mistake:
###   I expected git-pull would merge **all** updated branches
###   into the corresponding local branches: I wanted to update my local master.
git pull # Git warned me of that there's nothing to merge with no argument
### The message may be different by your git's configuration or version.
the_warning_message_I_got= <<END_OF_WARNING
 * [new branch]      master     -> origin/master
You asked me to pull without telling me which branch you
want to merge with, and 'branch.new-feature.merge' in
your configuration file does not tell me, either. Please
specify which branch you want to use on the command line and
try again (e.g. 'git pull <repository> <refspec>').
See git-pull(1) for details.

If you often merge with the same branch, you may want to
use something like the following in your configuration file:
    [branch "new-feature"]
    remote = <nickname>
    merge = <remote-ref>

    [remote "<nickname>"]
    url = <url>
    fetch = <refspec>

See git-config(1) for details.
END_OF_WARNING
echo $the_warning_message_I_got

### In the end, git did nothing.
git branch # => There wasn't branch master yet.

### To get the updates from origin/master, "git pull origin master:master" makes it,
### I assumed after taking a glance at the help page of git-pull.
git help pull
the_part_of_git_help_pull_I_read=<<END_OF_PART
<refspec>
           The format of a <refspec> parameter is an optional plus +,
           followed by the source ref <src>, followed by a colon :,
           followed by the destination ref <dst>.
END_OF_PART
echo $the_part_of_git_help_pull_I_read
git pull origin master:master
### But git unexpectedly merged origin/master not only the into local master,
### but also into my working branch: *new-feature*!
git log --pretty=oneline --abbrev-commit --graph
the_git_log_I_got=<<END_OF_LOG
*   5e81c4b Merge branch 'master' of /home/yu/t/reproduce-git/remote into new-feature
|\
  | * 63aeed2 Implement the feature
* 2033828 Implement some-of-new-feature.rb
END_OF_LOG
echo the_git_log_I_got

## Then, what should I had done? 
## ----------------------------------------

### Anyway, let my colleague to push a new commit onto origin/master,
### which will be properly merged into **only** the corresponding branch: master.
cd $colleague_repo
echo 'module ReallyCoolModule; end' > cool-module.rb
git add cool-module.rb
git commit -m"add ReallyCoolModule"
git push

### Then, I can pull the change(s) only into the local master
### **by checking out master in advance**,
### where I want to merge the upstream changes into the corresponding local branch.
cd $my_repo
git checkout master
git pull origin master
git log --pretty=oneline --abbrev-commit --graph
the_git_log_I_got=<<END_OF_LOG
* 81b1122 add ReallyCoolModule
* 5f625fe Implement the feature
END_OF_LOG
echo $the_git_log_I_got

### Check if the new update(s) in master is NOT merged into new-feature branch.
git checkout new-feature
git log --pretty=oneline --abbrev-commit --graph
the_git_log_I_got=<<END_OF_LOG
*   aff24dc Merge branch 'master' of /home/yu/t/reproduce-git/remote into new-feature
|\
| * 5f625fe Implement the feature
* 048625e Add some-of-new-feature.rb
END_OF_LOG
echo $the_git_log_I_got
### It worked! There's no commit made by my colleague before! I made it! Yay!

### By the way, you can also pull only into your-branch
### if you set up its upstream branch on the remote repository.
try_also_this=<<END_OF_NOTES
git checkout -b your-branch
echo 'def your_cool_method; end' > your-cool-method.rb
#        By -u option, specify which remote branch your-branch gets pulled/pushed into.
git push -u origin your-branch

# This is same as appending this entry to your local gitconfig:
equivalent_gitconfig=<<END_OF_GITCONFIG
    [branch "your-branch"]
    remote = origin
    merge = refs/heads/your-branch
END_OF_GITCONFIG
# You might realize that this looks like the configuration in the warning
# I got when git-pull-ed with no argument.
# The -u option of git-push automatically sets up the recommended
END_OF_NOTES
echo $try_also_this

CONCLUSION=<<END_OF_THIS_CASE
- "git pull origin master" pulls origin/master into YOUR WORKING BRANCH!
  So you should check out the branch you want to merge into, before "git pull"
- "git push -u origin new-branch" is useful.
  Use -u option anytime when you want to upload your branch onto the remote repository.
END_OF_THIS_CASE
echo $CONCLUSION
