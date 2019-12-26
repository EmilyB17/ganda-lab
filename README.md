# ganda-lab
General working files for the Ganda Lab at The Pennsylvania State University. SOPs, other protocols, working data, and script tutorials should be stored here. Stand-alone projects should be stored in their own repository. Read below for a basic guide on familiarizing with Github and RStudio, as well as Ganda Lab-specific style protocols.  

---  


# Git Started with Github  

**Version control SOP for Ganda Lab, Penn State University**  

## Git to know the jargon  

Git is a system of version control. Version control allows our lab to collaborate in a controlled way; this means that if someone makes a mistake, we can "unwind" it. We can also collaborate on code and share files, and store raw data and code for published projects in a permanent repository. Note that this explanation is overly basic for very beginners!  

A *repository* is a virtual filing cabinet. The repository stores folders and files. There is one general `ganda-lab` repository to store lab protocols, working data, script tutorials, etc. Each stand-alone project should have its own repository.  
Generally, each repository has one owner that controls the version control for the files in that repository. To make the collaborative process more efficient, we have *branches*. Branches are copies of the repository where an individual can make changes, add stuff, delete stuff - whatever - without changing the original `master branch`. The master branch stores the "working" repository.  

Collaborators need to use branches for effective version control. There are two ways to gain access to someone else's repository: you can `clone` the repository or `fork` the respository. *Cloning* creates a static copy of the repository that is locally downloaded. This is a great way to download software from Github, since you can still pull master changes to be up-to-date (more on this below). However, it is difficult to collaborate from a cloned repository. *Forking* creates a forked branch of the repository that is locally downloaded. From there, you can make changes and submit a *merge request* to push those changes back to the master branch. When you clone or fork a repository, you can change whatever you want to without affecting the other branches. 

What is all of this pushing and pulling? Basically: a `push` sends your staged and committed changes to the Github server. A `pull` refreshes your local repository from the Github server. Pushing and pulling changes make version control collaborative.

One final jargon to note: the merge system. Let's make an example: you own a repository that your collaborator has forked to their local machine. They have made changes to one of your R scripts in their own branch, and they want to make those changes permanent in the master branch. Your collaborator will push their changes in a `merge request`. This will send you a notification and you will be able to review their changes, Github will automatically check for any conflicts (like if you edited the code at the same time) and then you can allow the collaborator's branch to `merge` with the master branch and the changes become permanent.  
