# BASH Scripts

This is my personal repo of BASH scripts I am writing for my own personal use. If you find them useful--great. If you want to improve them, go for it. I am learning, so you will probably find plenty of stuff that could be done better.

## downloaded_file_cleanup.sh
⚠️ __Important: This script must be ran in the "parent" directory where the child folders are contained (which themselves hold the file(s)).__

This script is good for cleaning up files that may have been downloaded into a subfolder. It will pull the files out of the subfolders and move them into the parent directory. It can then delete the child folders from which the files were removed. Sometimes the folders are not empty, so it does so forcibly. The script has a menu system and does things in steps with prompts. It is descrucitve if completed out of order, so use with caution and at your own risk!

## install_webmin_debian_ubuntu.sh
This script installs the [WebMin](https://www.webmin.com/deb.html) interface on Ubuntu. I have tried to simplify the installation with the following code snippet. Just copy it and paste it into your Ubuntu terminal for an automated install. 
```
cd ~/ && wget https://raw.githubusercontent.com/djmoore711/bash-scripts/main/install_webmin_debian_ubuntu.sh && chmod u+x ./install_webmin_debian_ubuntu.sh && sudo ./install_webmin_debian_ubuntu.sh
```
## install_1password_linux.sh
This script automates the installation of 1Password on Linux systems by detecting the package manager, adding the 1Password repository, and installing the application. It logs installation progress and errors to a file while providing user feedback upon completion.
```
cd ~/ && wget https://raw.githubusercontent.com/djmoore711/bash-scripts/main/install_1password_linux.sh && chmod u+x ./install_1password_linux.sh && ./install_1password_linux.sh
```
