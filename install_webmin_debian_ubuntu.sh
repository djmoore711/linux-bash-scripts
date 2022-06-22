#!/usr/bin/env bash

##############################################################################
#
#   Author: DJ Moore
#   Created: 2022/06/19
#   Updated: 2022/06/22
#
##############################################################################

FILE=/etc/apt/sources.list
DIR=/etc/apt/sources.list.d
KEY=/usr/share/keyrings/webmin-jcameron-archive-keyring.gpg

header_check () {
    echo " "
    echo "##############################################################################"
    echo " "
    echo "Welcome to the automated install of WebMin "
    echo " "
    echo "This script will check for dependencies, install neccessary components,"
    echo "add a the WebMin repo to APT, import the required key, and install WebMin"
    echo " "
    read -r -p "Do you want to proceed? [Y/n] " input
    case $input in
        [yY][eE][sS]|[yY])
                echo "Proceeding with install"
                ;;
        [nN][oO]|[nN])
                echo "NOT proceeding with install"
                echo "Now exiting"
                ;;
        *)
                echo "Invalid input..."
                exit 1
                ;;
    esac
}

##### Function to check if /etc/apt/sources.list was updated properly
source_file_check () {
    if greg -q webmin $FILE; then
        echo "The $FILE file was updated successfully; proceeding with install."
    else
        echo "The $FILE file was not updated properly; exiting install."
        exit 1
    fi
}

created_source_file_check () {
    if greg -q webmin "$DIR/sources.list"; then
        echo "The $DIR/sources.list file was updated successfully; proceeding with install."
    else
        echo "The $DIR/sources.list file was not updated properly; exiting install."
        exit 1
    fi
}

add_webmin_apt_repo () {
    ##### Add Webmin to APT Repository
    if test -f "$FILE"; then
        echo "##############################################################################"
        echo " "
        echo "The $FILE file exists; adding repo to APT here."
        {
                echo " "
                echo "# Adding repository for WebMin"
                echo "deb [signed-by=/usr/share/keyrings/webmin-jcameron-archive-keyring.gpg] https://download.webmin.com/download/repository sarge contrib"
                } >> "$FILE"
        echo "The $FILE file has been updated."
        echo " "
        echo "Checking $FILE was updated properly."
        # Checking that the sources file was updated properly
        source_file_check
        echo " "
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
            echo "deb [signed-by=/usr/share/keyrings/webmin-jcameron-archive-keyring.gpg] https://download.webmin.com/download/repository sarge contrib"
            } >> "$DIR/sources.list"
        echo " "
        echo "The $DIR/sources.list file has been created and updated."
        echo " "
        echo "Checking the $DIR/sources.list file was updated properly"
        # Checking that the sources file was updated properly
        created_source_file_check
        echo " "
    fi
}

check_dependencies () {
    ##### Check for dependencies and install them if required
    WGET=$(which wget)
    GPG=$(which gpg)

    # WGET check and install
    if test -f "$WGET"; then
        echo "##############################################################################"
        echo " "
        echo "$WGET is already installed."
        echo " "

    else
        echo "##############################################################################"
        echo " "
        echo "Installing wget"
        echo " "
        apt install wget -y || { echo "Could not install wget"; exit 1; }
    fi

    # GPG check and install
    if test -f "$GPG"; then
        echo "##############################################################################"
        echo " "
        echo "$GPG is already installed."
        echo " "
    else
        echo "##############################################################################"
        echo " "
        echo "Installing gpg"
        echo " "
        apt install gpg -y || { echo "Could not install gpg"; exit 1; }
    fi
}

key_cleanup () {
    rm -f "$KEY"
}

apt_cleanup () {
    sed -i '/jcameron\|WebMin/d' "$FILE" || rm -f "$DIR/sources.list"
}

key_import_test () {
    echo "Checking that the key was properly imported; if not rolling back changes"
    if test -f "$KEY"; then
        echo "##############################################################################"
        echo "The key was imported successfully"
    else
        echo "##############################################################################"
        echo "Rolling back changes."
        key_cleanup
        apt_cleanup
        echo "All changes rolled back."
        exit 1
    fi
}

import_webmin_key () {
    ##### Installing GPG key for jcameron
    echo "##############################################################################"
    echo "Now importing public key for WebMin repository"
    echo " "
    cd ~ || { echo "Could not move to home directory"; exit 1; }
    wget -O- https://download.webmin.com/jcameron-key.asc |
    gpg --dearmor |
    tee /usr/share/keyrings/webmin-jcameron-archive-keyring.gpg ||
    { echo "Key was not successfully imported. Exiting install."; exit 1; }
    key_import_test
}

install () {
    ##### Update ATP and install WebMin
    echo " "
    echo "##############################################################################"
    echo "Now updating and installing WebMin. Please wait."
    apt install apt-transport-https
    apt update
    apt install webmin -y
    echo " "
    echo " "
}

check_install() {
    WMIN=$(which webmin)
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


##### Function to install WebMin on Ubuntu
main () {

    header_check

    check_dependencies

    add_webmin_apt_repo

    import_webmin_key

    install

    check_install

}

##### Checking if WebMin is already installed
WMINCHK=$(which webmin)
if test -f "$WMINCHK"; then
    echo " "
    echo "WebMin is already installed. Now exiting..."
    echo " "
    exit
else
    main
fi
