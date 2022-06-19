#!/usr/bin/env bash

##############################################################################
#
#   Author: DJ Moore
#   Created: 2022/06/19
#
##############################################################################

##### Checking if WebMin is already installed
WMINCHK=$(which webmin)
if test -f "$WMINCHK"; then
    echo "WebMin is already installed. Now exiting..."
    exit
else
    install
fi

#   Function to install WebMin on Ubuntu
install () {
    echo "WebMin is not installed, proceeding with installation..."

    ##### Check for dependencies and install them if required
    WGET=$(which wget)
    GPG=$(which gpg)

    # WGET check and install
    if test -f "$WGET"; then
        echo "$WGET is already installed."
    else
        echo "Installing wget"
        apt install wget -y
    fi

    # GPG check and install
    if test -f "$GPG"; then
        echo "$GPG is already installed."
    else
        echo "Installing gpg"
        apt install gpg -y
    fi


    ##### Add Webmin to APT Repository
    FILE=/etc/apt/sources.list
    DIR=/etc/apt/sources.list.d
    if test -f "$FILE"; then
        echo "$FILE exists."
        {
                echo "# Adding repository for WebMin"
                echo "deb https://download.webmin.com/download/repository sarge contrib"
                } >> "$FILE"
    else
        echo "$FILE does not exist, adding repository another way."
        mkdir -p "$DIR"
        cd "$DIR/" || { echo "Failure"; exit 1; }
        touch "sources.list"
        {
                echo "# Adding repository for WebMin"
                echo "deb [signed-by=/usr/share/keyrings/jcameron-key.gpg]"
                echo "https://download.webmin.com/download/repository sarge contrib"
                } >> "$DIR/sources.list"
    fi

    ##### Installing GPG key for jcameron
    cd /root || { echo "Failure"; exit 1; }
    wget https://download.webmin.com/jcameron-key.asc
    cat jcameron-key.asc | gpg --dearmor >/usr/share/keyrings/jcameron-key.gpg

    ##### Update ATP and install WebMin
    apt install apt-transport-https
    apt update
    apt install webmin

    ##### Checking install
    WMIN=$(which webmin)

    # WebMin check
    if test -f "$WMIN"; then
        echo "WebMin installed properly! Now exiting."
        exit
    else
        echo "Something went wrong with the install process"
        echo "Visit https://www.webmin.com/deb.html for more information"
        exit
    fi
}
