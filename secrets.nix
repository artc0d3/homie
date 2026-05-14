# Declarative secret management via sops-nix
#
# Secrets are stored encrypted at rest in /var/lib/secrets/ (outside the repo).
# At activation time, sops-nix decrypts them to /run/secrets/ (tmpfs) using an
# age key derived from the SSH host key.
#
# See README.md for provisioning instructions.
{ config, ... }:
{
  sops = {
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

    # Secrets live outside the Nix store (in /var/lib/secrets/), so skip
    # build-time path validation. They are provisioned out-of-band.
    validateSopsFiles = false;

    secrets."sys.user.homie" = {
      sopsFile = "/var/lib/secrets/sys.user.homie";
      format = "binary";
      neededForUsers = true;
    };

    secrets."samba.homie.passwd" = {
      sopsFile = "/var/lib/secrets/samba.homie.passwd";
      format = "binary";
      owner = "root";
      mode = "0400";
    };
  };
}
