#!/bin/bash

WGET=$(which wget)

checkInstallWget()
{
    # WGET check and install
    if test -f "$WGET"; then
        echo -e "$WGET is already installed. Continuing... \n"

    else
        echo -e "Installing wget. \n"
        sudo apt install wget -y || { echo -e "Could not install wget \n"; exit 1; }
    fi
}

downloadGeekbench()
{
    echo -e "Downloading Geekbench to the current working directory. \n"
    wget "https://cdn.geekbench.com/Geekbench-5.4.5-Linux.tar.gz"
}

unzipGeekbench()
{
    echo -e "Now unzipping the Geekbench download. \n"
    tar -xf ./Geekbench-5.4.5-Linux.tar.gz
    cd ./Geekbench-5.4.5-Linux
}

runGeekbench()
{
    echo -e "Now running Geekbench 5. \n"
    ./geekbench5
}

justRunGeekbench()
{
    echo -e "Now running Geekbench 5. \n"
    $GBCHECK
}

downloadAndRun()
{
    checkInstallWget

    downloadGeekbench

    unzipGeekbench

    runGeekbench
}

onlyRun()
{
    justRunGeekbench
}

##### Checking if Geekbench is already downloaded
GBCHECK=$(sudo find /home -name geekbench5)
if test -f "$GBCHECK"; then
    echo -e "Geekbench is already downloaded. Running now... \n"
    onlyRun
else
    downloadAndRun
fi 


