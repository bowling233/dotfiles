#!/bin/bash
# https://docs.docker.com/engine/install/ubuntu/
# https://docs.docker.com/engine/install/debian/
# https://docs.docker.com/engine/install/linux-postinstall/

set -xe

if [ -x "$(command -v docker)" ]; then
  echo "Docker is installed"
  exit 0
fi

if [ -f /etc/os-release ]; then
  . /etc/os-release
  OS=$ID
  if [ "$OS" != "ubuntu" ] && [ "$OS" != "debian" ]; then
    echo "OS not supported"
    exit 1
  fi
else 
  echo "OS not supported"
  exit 1
fi

pkgs=(docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc)
sudo apt-get remove -y "${pkgs[@]}"

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/$OS/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/$OS \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# check if docker group exists
if ! getent group docker; then
	sudo groupadd docker
	echo 'Log out and log back in so that your group membership is re-evaluated.'
fi
