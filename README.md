# ganda-lab
General working files for the Ganda Lab at The Pennsylvania State University. SOPs, other protocols, working data, and script tutorials should be stored here. Stand-alone projects should be stored in their own repository. Read below for a basic guide on familiarizing with Github and RStudio, as well as Ganda Lab-specific style protocols.  

Contents:  
1. Git started with Github (for very beginners - skip this if you are already familiar with Git)
2. Setting up GitHub with RStudio
3. General best practices
---  


## Git started with Github  

Git is a system of version control. Version control allows our lab to collaborate in a controlled way; this means that if someone makes a mistake, we can "unwind" it. We can also collaborate on code and share files, and store raw data and code for published projects in a permanent repository. Note that this explanation is overly basic for very beginners!  

A *repository* is a virtual filing cabinet. The repository stores folders and files. There is one general `ganda-lab` repository to store lab protocols, working data, script tutorials, etc. Each stand-alone project should have its own repository.  
Generally, each repository has one owner that controls the version control for the files in that repository. To make the collaborative process more efficient, we have *branches*. Branches are copies of the repository where an individual can make changes, add stuff, delete stuff - whatever - without changing the original `master branch`. The master branch stores the "working" repository.  

Collaborators need to use branches for effective version control. There are two ways to gain access to someone else's repository: you can `clone` the repository or `fork` the respository. *Cloning* creates a static copy of the repository that is locally downloaded. This is a great way to download software from Github, since you can still pull master changes to be up-to-date (more on this below). However, it is difficult to collaborate from a cloned repository. *Forking* creates a forked branch of the repository that is locally downloaded. From there, you can make changes and submit a *merge request* to push those changes back to the master branch. When you clone or fork a repository, you can change whatever you want to without affecting the other branches. 

What is all of this pushing and pulling? Basically: a `push` sends your staged and committed changes to the Github server. A `pull` refreshes your local repository from the Github server. Pushing and pulling changes make version control collaborative.

One final jargon to note: the merge system. Let's make an example: you own a repository that your collaborator has forked to their local machine. They have made changes to one of your R scripts in their own branch, and they want to make those changes permanent in the master branch. Your collaborator will push their changes in a `merge request`. This will send you a notification and you will be able to review their changes, Github will automatically check for any conflicts (like if you edited the code at the same time) and then you can allow the collaborator's branch to `merge` with the master branch and the changes become permanent.  

## Setting up Git with RStudio

My favorite beginner's guide to setting up Git and "talking" with RStudio is [Using Git with RStudio](https://jennybc.github.io/2014-05-12-ubc/ubc-r/session03_git.html). Follow these directions, but STOP at "Learn to use Git with RStudio". Here's why: there are two ways to initialize a repository with RStudio. One is to start an R project and check the "create Git repository box" for it. The second is to start a repository on Github and clone it to checkout an R project. *The second way is more user-friendly!* Starting a repository through Github automatically adds a README.md file. Check out these instructions at [Happy Git with R](https://happygitwithr.com) starting at Chapter 15. This is a more complex tutorial but well worth it!

For basic day-to-day use, you should be able to:  
1. Start a new repository and clone it to an RStudio package
2. Work in the repository, commiting changes as you go
3. Push your finished work to Github 
4. Pull your Github repo at the start of the next work session. 

To be able to collaborate, you should be able to follow Chapter 28 in Happy Git with R to:
1. Fork and clone another person's respository
2. Get upstream changes
3. Make your own working branch
4. Make necessary changes and commits
5. Submit pull request

## General best practices

Version control only works properly if used correctly! For the best collaboration, make sure to adhere to the following:  

* Commit early and often. Always commit changes before making a "big" change 
* Commit notes should have a general explanation of what the commit contains. "Updated code" is not as helpful as "fixed error in line 13 read_table"
* Get in the habit of pulling any changes before you start work! 
* Generally, each repository should have an `R` folder and a `data` folder, as well as a README.md file
* Raw data should be accompanied by a metadata text file explaining the content
* If possible, code should read in data in raw form directly from Github 


hola 

