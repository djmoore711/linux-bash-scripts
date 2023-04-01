#!/bin/bash

# Function that moves the files to the parent directory
function move_files {
    echo
    echo "Moving .$filetype files to the parent directory..."
    echo "--------------------------------------------------"
    find . -name "*.$filetype" -execdir mv -v {} ../ \;
}

# Asking the user to proceed with moving files
function ask_move_files {
    read -p 'What filetype do you want to move up a directory? (e.g., mp4, avi, jpg): ' filetype
    echo
    read -p "Are you ready to move all .$filetype files? (Y/n) " answer
    echo

    case "$answer" in
        [yY]*)
            echo "Moving files..."
            move_files
            menu
            ;;
        [nN]*)
            echo "No files will be moved. Exiting."
            echo "--------------------------------------------------"
            exit
            ;;
        *)
            echo "Invalid answer. Please answer with 'y' or 'n'."
            ask_move_files
            ;;
    esac
}

# Function that deletes the now empty parent folders
function delete_folders {
    echo
    echo "Deleting child-level folders now..."
    echo "--------------------------------------------------"
    rm -fr */
}

# Asking the user to proceed with deleting the now empty folders
function ask_delete_folders {
    read -p "Are you ready to delete the old, empty folders? (Y/n) " answer
    echo

    case "$answer" in
        [yY]*)
            echo "Deleting folders..."
            delete_folders
            echo "Folders deleted!"
            echo "--------------------------------------------------"
            menu
            ;;
        [nN]*)
            echo "No folders will be deleted. Exiting."
            echo "--------------------------------------------------"
            exit
            ;;
        *)
            echo "Invalid answer. Please answer with 'y' or 'n'."
            ask_delete_folders
            ;;
    esac
}

function menu {
    PS3="Select a menu number: "
    echo "--------------------------------------------------"
    echo "| This script is designed to pull specific       |"
    echo "| filetypes from all child folders in a directory,|"
    echo "| move them into the parent directory,            |"
    echo "| and then delete the old empty child folders.   |"
    echo "--------------------------------------------------"
    select option in "Move Files" "Delete Folders" "Quit"; do
        case "$option" in
            "Move Files")
                ask_move_files
                ;;
            "Delete Folders")
                ask_delete_folders
                ;;
            "Quit")
                echo "Quitting the script..."
                echo "--------------------------------------------------"
                exit
                ;;
            *)
                echo "Invalid selection. Please choose 1, 2, or 3."
                ;;
        esac
    done
}

menu
