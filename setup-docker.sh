#!/bin/bash

# Check for root user
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root (e.g. sudo $0)"
  exit 1
fi

# Update package index and install prerequisites
apt-get update
apt-get install -y ca-certificates curl

# Prepare keyrings directory
install -m 0755 -d /etc/apt/keyrings

# Download Docker’s GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

# Add Docker repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update and install Docker components with automatic yes
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

if ! getent group docker >/dev/null; then
  groupadd docker
fi

usermod -aG docker "$SUDO_USER"

echo "Docker installed and added $SUDO_USER to docker group. You may need to log out and back in for group changes to apply."