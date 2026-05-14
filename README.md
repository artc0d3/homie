# Homie

A NixOS server configuration for a home NAS server. Provides a modern, secure,
and efficient setup for managing your home data, media, and services.

## Services

- **Samba** — SMB3 file sharing for `/data`
- **Jellyfin** — media server
- **Avahi** — mDNS/DNS-SD for local network discovery
- **SSH** — remote access

## Installation

### Install NixOS

Install NixOS according to the [official guide](https://nixos.wiki/wiki/NixOS_Installation_Guide).

### Set up secrets

Once you have a fresh NixOs installation, the first step is to setup your secrets.
Secrets are encrypted at rest in `/var/lib/secrets/` using [sops-nix](https://github.com/Mic92/sops-nix).
Follow these steps to setup the secrets:

1. Generate `.sops.yaml` from the SSH host key:

```bash
sudo nix-shell -p ssh-to-age --run '
  key=$(ssh-to-age < /etc/ssh/ssh_host_ed25519_key.pub)
  cat > /var/lib/secrets/.sops.yaml <<EOF
creation_rules:
  - age: "$key"
EOF
'
```

2. Encrypt secrets:

```bash
# Password for the shell user 'homie' 
sudo nix-shell -p sops --run '
  mkpasswd -m sha-512 | sops --input-type binary --output-type binary \
  -e /dev/stdin > /var/lib/secrets/system.user.homie 
'

# Password for the Samba user 'homie'. 
sudo nix-shell -p sops --run '
  read -s -p "Samba password: " pw && echo "$pw" | \
  sops --input-type binary --output-type binary \
  -e /dev/stdin > /var/lib/secrets/samba.homie.passwd
'
```

3. Set file permissions:

```bash
sudo chmod 0600 /var/lib/secrets/*
```

### Install Homie

After setting up the secrets your're ready to apply the Homie NixOS configuration:

```bash
sudo nixos-rebuild switch --flake "github:artc0d3/homie#nixos"
```
