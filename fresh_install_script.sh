#!/usr/bin/bash
set -o errexit
set -o nounset

Apps=('vim', 'ubuntu-restricted-extras', 'timeshift')

status=$?
check_status () {

    # Check the status of the previously ran command and exit with the failure
    # code

    if [ "$status" -eq 0 ]
    then
        printf "The command ran successfully.\n"
    else
        printf "The command was not successful. Error: $status.\n"
        exit "$status"
    fi
}

update_system () {
	printf "Updating everything before proceeding...\n"
    # Starting the update process before installing all the software I want
	printf "Updating repositories now...\n"
	sudo apt update > /dev/null 2>&1
	check_status
	printf "Performing a full upgrade now... \n"
	sudo apt full-upgrade -y > /dev/null 2>&1
	check_status
}

fish_shell () {
	printf "Adding the PPA for and installing the fish shell. \n"
	sudo apt-add-repository ppa:fish-shell/release-3 > /dev/null 2>&1
	check_status
	update_system
	sudo apt install fish > /dev/null 2>&1
	check_status
	printf "Setting fish as the default shell (requires terminal restart). \n"
	sudo chsh -s /usr/local/bin/fish > /dev/null 2>&1
	check_status
}

install_func () {
	printf "Checking for $1 and installing if missing.\n"
	if ! [ -x "$(command -v $1)" ]; then
		sudo apt install "$1" > /dev/null 2>&1
		check_status
	else
		printf "$1 was already installed. \n"
	fi
}

app_install_loop () {
	for app in "${Apps[@]}"
	do
		printf "We are about to install all of the apps in the list. \n"
		install_func "$app"
	done
}

main () {

	# This part of the script runs the entire program

	update_system
	app_install_loop
	fish_shell
}

# Calling the main function
main 
