#!/usr/bin/env bash

##############################################################################
#
#   Author: DJ Moore
#   Created: 2022/06/19
#
##############################################################################

##### Function to install WebMin on Ubuntu
install () {
    echo " "
    echo "##############################################################################"
    echo " "
    echo "Welcome to the automated install of WebMin "
    echo " "
    echo "This script will check for dependencies, install neccessary components,"
    echo "add a the WebMin repo to APT, import the required key, and install WebMin"
    echo " "
    echo "Proceeding with installation... "
    echo " "
    echo "##############################################################################"


    ##### Check for dependencies and install them if required
    WGET=$(which wget)
    GPG=$(which gpg)

    # WGET check and install
    if test -f "$WGET"; then
        echo "##############################################################################"
        echo " "
        echo "$WGET is already installed."
        echo " "
        echo "##############################################################################"

    else
        echo "##############################################################################"
        echo " "
        echo "Installing wget"
        echo " "
        echo "##############################################################################"
        apt install wget -y
    fi

    # GPG check and install
    if test -f "$GPG"; then
        echo "##############################################################################"
        echo " "
        echo "$GPG is already installed."
        echo " "
        echo "##############################################################################"
    else
        echo "##############################################################################"
        echo " "
        echo "Installing gpg"
        echo " "
        echo "##############################################################################"
        apt install gpg -y
    fi


    ##### Add Webmin to APT Repository
    FILE=/etc/apt/sources.list
    DIR=/etc/apt/sources.list.d
    if test -f "$FILE"; then
        echo "##############################################################################"
        echo " "
        echo "The $FILE file exists; adding repo to APT here."
        {
                echo " "
                echo "# Adding repository for WebMin"
                echo "deb [signed-by=/usr/share/keyrings/jcameron-key-archive-keyring.gpg]"
                echo "https://download.webmin.com/download/repository sarge contrib"
                } >> "$FILE"
        echo "The $FILE file has been updated."
        echo " "
        echo "##############################################################################"
    else
        echo "##############################################################################"
        echo " "
        echo "The $FILE file does not exist, adding repository manually."
        mkdir -p "$DIR"
        cd "$DIR/" || { echo "Could not move to $DIR"; exit 1; }
        touch "sources.list"
        {
            echo " "
            echo "# Adding repository for WebMin"
            echo "deb [signed-by=/usr/share/keyrings/jcameron-key.gpg]"
            echo "https://download.webmin.com/download/repository sarge contrib"
            } >> "$DIR/sources.list"
        echo " "
        echo "The $DIR/sources.list file has been created and updated."
        echo " "
        echo "##############################################################################"
        echo " "
    fi

    ##### Installing GPG key for jcameron
    echo "##############################################################################"
    echo "Now importing public key for WebMin repository"
    cd ~ || { echo "Could not move to home directory"; exit 1; }
    wget https://download.webmin.com/jcameron-key.asc
    cat ./jcameron-key.asc |
    gpg --dearmor |
    sudo tee /usr/share/keyrings/webmin-jcameron-archive-keyring.gpg

    ##### Check if key was installed
    KEY=/usr/share/keyrings/webmin-jcameron-archive-keyring.gpg
    if test -f "$KEY"; then
        echo " "
        echo "Key successfully imported! Continuing with installation."
        echo " "
        echo "##############################################################################"

    else
        echo " "
        { echo "Key was not successfully imported. Exiting install."; exit 1; }
        echo " "
        echo "##############################################################################"
    fi

    ##### Update ATP and install WebMin
    echo " "
    echo "##############################################################################"
    echo "Now updating and installing WebMin. Please wait."
    apt install apt-transport-https
    apt update
    apt install webmin -y
    echo " "
    echo " "
    echo " "

    ##### Checking install
    WMIN=$(which webmin)

    # WebMin check
    if test -f "$WMIN"; then
        echo "WebMin installed properly! Now exiting."
        echo "##############################################################################"
        exit
    else
        echo "Something went wrong with the install process"
        echo "Visit https://www.webmin.com/deb.html for more information"
        echo "##############################################################################"
        exit
    fi
}

##### Checking if WebMin is already installed
WMINCHK=$(which webmin)
if test -f "$WMINCHK"; then
    echo " "
    echo "WebMin is already installed. Now exiting..."
    echo " "
    exit
else
    install
fi
