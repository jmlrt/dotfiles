Dotfiles
========

My dotfiles are in .src directory
I use the Makefile to manage them

Instructions
------------

1. Clone the repository in your $HOME folder. This will create a Makefile and a .src directory which contains the dotfiles
2. Run ``make install`` to deploy the dotfiles. 
 - This will create a $HOME/.bak directory which is a local git repository for versionned backups
 - This will copy the old dotfiles in .bak directory and make a git commit
 - Then this will install the new dotfiles
