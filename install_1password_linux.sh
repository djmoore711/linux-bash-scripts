#!/bin/bash

set -e

LOG_FILE="1password_installation.log"

log() {
  local message="$1"
  echo "$(date +"%Y-%m-%d %T") - ${message}" | tee -a "${LOG_FILE}"
}

is_1password_installed() {
  if command -v 1password >/dev/null 2>&1; then
    return 0
  else
    return 1
  fi
}

# Check if 1Password is already installed
if is_1password_installed; then
  log "1Password is already installed on your system."
  exit 0
fi

install_1password_apt() {
  log -e "\nInstalling dependencies...\n"
  sleep 2
  sudo apt-get update && sudo apt-get install -y curl gnupg2 || {
    log "Error: Failed to install dependencies."
    exit 1
  }
  sleep 2

  log -e "\nAdding 1Password repository...\n"
  sleep 2
  curl -sS https://downloads.1password.com/linux/keys/1password.asc | gpg --dearmor --output /tmp/1password.gpg || {
    log "Error: Failed to download the 1Password signing key."
    exit 1
  }
  sleep 2

  sudo install -o root -g root -m 644 /tmp/1password.gpg /etc/apt/trusted.gpg.d/ || {
    log "Error: Failed to install the 1Password signing key."
    exit 1
  }
  sleep 2

  log -e '\nAdding 1Password repository to /etc/apt/sources.list.d/1password.list...\n'
  sleep 2
  log 'deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/1password.gpg] https://downloads.1password.com/linux/debian/amd64 stable main' | sudo tee /etc/apt/sources.list.d/1password.list || {
    log "Error: Failed to add the 1Password repository."
    exit 1
  }
  sleep 2

  log -e "\nUpdating package list and installing 1Password...\n"
  sleep 2
  sudo apt-get update || {
    log "Error: Failed to update package list."
    exit 1
  }
  sleep 2

  sudo apt-get install 1password || {
    log "Error: Failed to install 1Password."
    exit 1
  }
  sleep 2
}

install_1password_rpm() {
  log -e "\nInstalling dependencies...\n"
  sleep 2
  sudo $1 install -y curl gnupg2 || {
    log "Error: Failed to install dependencies."
    exit 1
  }
  sleep 2

  log -e "\nAdding 1Password repository...\n"
  sleep 2
  curl -sS https://downloads.1password.com/linux/keys/1password.asc | gpg --dearmor --output /tmp/1password.gpg || {
    log "Error: Failed to download the 1Password signing key."
    exit 1
  }
  sleep 2

  sudo install -o root -g root -m 644 /tmp/1password.gpg /etc/pki/rpm-gpg/RPM-GPG-KEY-1password || {
    log "Error: Failed to install the 1Password signing key."
    exit 1
  }
  sleep 2

  log -e '\nAdding 1Password repository to /etc/yum.repos.d/1password.repo...\n'
  sleep 2
  log -e "[1password]\nname=1Password Repository\nbaseurl=https://downloads.1password.com/linux/rpm/stable/\$basearch\nenabled=1\ngpgcheck=1\ngpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-1password\nmetadata_expire=86400" | sudo tee /etc/yum.repos.d/1password.repo || {
    log "Error: Failed to add the 1Password repository."
    exit 1
  }
  sleep 2

  log -e "\nInstalling 1Password...\n"
  sleep 2
  sudo $1 install -y 1password || {
    log "Error: Failed to install 1Password."
    exit 1
  }
  sleep 2
}

install_1password_pacman() {
  log -e "\nInstalling dependencies...\n"
  sleep 2
  sudo pacman -Sy --noconfirm curl gnupg2 || {
    log "Error: Failed to install dependencies."
    exit 1
  }
  sleep 2

  log -e "\nAdding 1Password repository...\n"
  sleep 2
  curl -sS https://downloads.1password.com/linux/keys/1password.asc | gpg --dearmor --output /tmp/1password.gpg || {
    log "Error: Failed to download the 1Password signing key."
    exit 1
  }
  sleep 2

  sudo install -o root -g root -m 644/tmp/1password.gpg /etc/pacman.d/gnupg/pubring.gpg || {
    log "Error: Failed to install the 1Password signing key."
    exit 1
  }
  sleep 2

  log -e '\nAdding 1Password repository to /etc/pacman.conf...\n'
  sleep 2
  log -e "\n[1password]\nSigLevel = Optional TrustAll\nServer = https://downloads.1password.com/linux/arch/stable/\$arch" | sudo tee -a /etc/pacman.conf || {
    log "Error: Failed to add the 1Password repository."
    exit 1
  }
  sleep 2

  log -e "\nUpdating package list and installing 1Password...\n"
  sleep 2
  sudo pacman -Syu --noconfirm 1password || {
    log "Error: Failed to install 1Password."
    exit 1
  }
  sleep 2
}

# Detect package manager
if command -v apt-get >/dev/null 2>&1; then
  PACKAGE_MANAGER="apt"
elif command -v dnf >/dev/null 2>&1; then
  PACKAGE_MANAGER="dnf"
elif command -v yum >/dev/null 2>&1; then
  PACKAGE_MANAGER="yum"
elif command -v pacman >/dev/null 2>&1; then
  PACKAGE_MANAGER="pacman"
else
  log "Error: Unsupported package manager. This script supports APT, DNF, YUM, and PACMAN."
  exit 1
fi

# Run installation function for the detected package manager
if [ "$PACKAGE_MANAGER" == "apt" ]; then
  install_1password_apt
elif [ "$PACKAGE_MANAGER" == "dnf" ] || [ "$PACKAGE_MANAGER" == "yum" ]; then
  install_1password_rpm "$PACKAGE_MANAGER"
elif [ "$PACKAGE_MANAGER" == "pacman" ]; then
  install_1password_pacman
fi

log -e "\n1Password installation successful! You can now launch 1Password from the application menu or by running '1password' in the terminal.\n"
