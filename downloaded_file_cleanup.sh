#!/bin/bash

# Function that moves the files to the parent directory
function moveFiles {
    echo
    echo "Moving files... with the .$filetype extension."
    echo "--------------------------------------------------------------------------------"
    find . -name "*.$filetype" -execdir mv -v {} ../ \;
}

# Asking the user to proceed with moving files
function askMoveFiles {
    echo
    read -p 'What filetype do you want to move up a directory? (eg., mp4, avi, jpg): ' filetype
    echo 
    read -p "Are you ready to move all of the .$filetype files? (Y/n) " yn
    echo 
    while true; do
        case $yn in 
            [yY] ) 
                echo
                echo "Your files will be moved now.";
                echo
                moveFiles;
                menu;
                break;;
            [nN] ) 
                echo
                echo "No files will be moved. Exiting.";
                echo "--------------------------------------------------------------------------------"
                exit;;
            * ) 
                echo
                echo "You pressed the wrong key. Try again."
                echo "--------------------------------------------------------------------------------";;
        esac
    done
}

# Function that deletes the now empty parent folders
function delFolders {
    echo
    echo "Deleting child-level folders now."
    echo "--------------------------------------------------------------------------------"
    rm -fr */
}

# Asking the user to proceed with deleting the now empty folders
function askDelFolders {
    while true; do
        echo 
        read -p "Are you ready to delete the old, empty folders? (Y/n) " yn
        echo 
        case $yn in 
            [yY] ) 
                echo
                echo "The folders will be deleted now.";
                echo
                delFolders;
                echo
                echo "Folders deleted!"
                echo "--------------------------------------------------------------------------------"
                menu;
                break;;
            [nN] ) 
                echo
                echo "No files will be moved. Exiting.";
                echo "--------------------------------------------------------------------------------"
                exit;;
            * ) 
                echo
                echo "You pressed the wrong key. Try again."
                echo "--------------------------------------------------------------------------------";;
        esac
    done
}

function menu {
PS3="Select a menu number: "
echo "--------------------------------------------------------------------------------"
echo "| This script is designed to pull specific filetypes from all child folders    |"
echo "| in a directory, move them into the parent directory, and then delete the old |"
echo "| empty child folders.                                                         |"
echo "--------------------------------------------------------------------------------"
choice=("Move Files" "Delete Folders" "Quit")
select i in "${choice[@]}" ; do
    case $i in
        "Move Files" )
            askMoveFiles;
            ;;
        "Delete Folders" )
            askDelFolders;
            ;;
        "Quit" )
            echo
            echo "Quitting the script..."
            echo
            exit;;
        * )
            echo
            echo "Invalid Selection: $REPLY"
            echo
            break;;
    esac
done 
}

menu 
