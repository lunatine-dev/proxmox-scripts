# VM Setup Scripts

Just some scripts I run on my proxmox VMs to make it a bit easy to manage

## Included Scripts

-   `setup-docker.sh` — Installs Docker and related components.
-   `secure-ssh.sh` — Disables password authentication and ensures pubkey authentication is allowed

## Usage

Run the scripts on your VM to quickly set up the required software and services.

### Setup docker

```bash
curl -sSL https://raw.githubusercontent.com/lunatine-dev/proxmox-scripts/main/setup-docker.sh | sudo bash
```

### Secure SSH

```bash
curl -sSL https://raw.githubusercontent.com/lunatine-dev/proxmox-scripts/main/secure-ssh.sh | sudo bash
```
