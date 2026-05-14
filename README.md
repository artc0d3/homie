# Homie

A NixOS server configuration for a home NAS server. Provides a modern, secure,
and efficient setup for managing your home data, media, and services.

## Services

- **Samba** — SMB3 file sharing for `/data`
- **Jellyfin** — media server
- **Avahi** — mDNS/DNS-SD for local network discovery
- **SSH** — remote access

## Building

```bash
nixos-rebuild build --flake '.#nixos' --refresh
```

## Secret Management

Secrets are encrypted at rest in `/var/lib/secrets/` using
[sops-nix](https://github.com/Mic92/sops-nix). At activation time, they are
decrypted to `/run/secrets/` (tmpfs) using an age key derived from the machine's
SSH host key. Secrets are never stored in this repository.

### Managed secrets

| Secret | Format | Purpose |
|--------|--------|---------|
| `sys.user.homie` | hashed (sha-512) | System user password |
| `samba.homie.passwd` | plaintext | Samba password (used by `smbpasswd`) |

### Initial setup (bare system)

After installing NixOS and booting for the first time:

**1. Generate `.sops.yaml` from the SSH host key:**

```bash
nix-shell -p ssh-to-age --run '
  key=$(ssh-to-age < /etc/ssh/ssh_host_ed25519_key.pub)
  cat > /var/lib/secrets/.sops.yaml <<EOF
creation_rules:
  - age: "$key"
EOF
'
```

**2. Encrypt secrets:**

```bash
# System user password (hashed)
mkpasswd -m sha-512 | sops --input-type binary --output-type binary \
  -e /dev/stdin > /var/lib/secrets/sys.user.homie

# Samba password (plaintext)
read -s -p "Samba password: " pw && echo "$pw" | \
  sops --input-type binary --output-type binary \
  -e /dev/stdin > /var/lib/secrets/samba.homie.passwd
```

**3. Apply the configuration:**

```bash
nixos-rebuild switch --flake '.#nixos'
```

### Rotating a secret

To update an existing secret, decrypt it in place, edit, and re-encrypt:

```bash
sops /var/lib/secrets/<secret-file>
```

Then rebuild:

```bash
nixos-rebuild switch --flake '.#nixos'
```
