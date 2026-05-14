# Samba file sharing for /data
#
# The Samba password for the homie user is managed by sops-nix.
# See README.md for provisioning instructions.
{ config, pkgs, ... }:
let
  passwordFile = config.sops.secrets."samba.homie.passwd".path;
in
{
  # Set the Samba password from a file after activation.
  # Depends on setupSecrets so sops-nix has decrypted the password first.
  system.activationScripts.postActivation = {
    deps = [ "setupSecrets" ];
    text = ''
      if [ -f "${passwordFile}" ]; then
        PASSWORD=$(<"${passwordFile}")
        printf '%s\n%s\n' "$PASSWORD" "$PASSWORD" | ${pkgs.samba}/bin/smbpasswd -s -a homie
      fi
    '';
  };

  services.samba = {
    enable = true;
    openFirewall = true;

    settings = {
      global = {
        "workgroup" = "WORKGROUP";
        "server string" = "homie";
        "server role" = "standalone server";

        # Security settings
        "map to guest" = "never";
        "server min protocol" = "SMB3";
        "smb encrypt" = "required";
        "passwd program" = "/run/wrappers/bin/passwd %u";
      };

      data = {
        path = "/data";
        browseable = "yes";
        "read only" = "no";
        "valid users" = "homie";
        "create mask" = "0664";
        "directory mask" = "0774";

        # Disable caching to keep Windows clients in sync
        "oplocks" = "no";
        "level2 oplocks" = "no";
        "kernel oplocks" = "no";
      };
    };
  };

  # Enable mDNS/DNS-SD so the share is discoverable on the local network
  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };
}
