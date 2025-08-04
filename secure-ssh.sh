#!/bin/bash
# secure_ssh.sh
# This script hardens SSH by disabling password auth and forcing public key auth only.

set -e

SSHD_CONFIG="/etc/ssh/sshd_config"
BACKUP="${SSHD_CONFIG}.bak.$(date +%F-%T)"

echo "[*] Backing up original sshd_config to $BACKUP"
cp "$SSHD_CONFIG" "$BACKUP"

echo "[*] Updating sshd_config settings..."

# Disable PasswordAuthentication
if grep -q "^PasswordAuthentication" "$SSHD_CONFIG"; then
  sed -i 's/^PasswordAuthentication.*/PasswordAuthentication no/' "$SSHD_CONFIG"
else
  echo "PasswordAuthentication no" >> "$SSHD_CONFIG"
fi

# Disable ChallengeResponseAuthentication
if grep -q "^ChallengeResponseAuthentication" "$SSHD_CONFIG"; then
  sed -i 's/^ChallengeResponseAuthentication.*/ChallengeResponseAuthentication no/' "$SSHD_CONFIG"
else
  echo "ChallengeResponseAuthentication no" >> "$SSHD_CONFIG"
fi

# Disable PermitRootLogin password authentication
if grep -q "^PermitRootLogin" "$SSHD_CONFIG"; then
  sed -i 's/^PermitRootLogin.*/PermitRootLogin prohibit-password/' "$SSHD_CONFIG"
else
  echo "PermitRootLogin prohibit-password" >> "$SSHD_CONFIG"
fi

# Ensure PubkeyAuthentication is enabled
if grep -q "^PubkeyAuthentication" "$SSHD_CONFIG"; then
  sed -i 's/^PubkeyAuthentication.*/PubkeyAuthentication yes/' "$SSHD_CONFIG"
else
  echo "PubkeyAuthentication yes" >> "$SSHD_CONFIG"
fi

echo "[*] Reloading sshd service to apply changes..."
if command -v systemctl &>/dev/null; then
  systemctl reload sshd
elif command -v service &>/dev/null; then
  service ssh reload
else
  echo "[!] Could not reload sshd service. Please reload manually."
fi

echo "[+] SSH configuration updated successfully. Password authentication is disabled."