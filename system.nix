{
  config,
  lib,
  pkgs,
  ...
}:
let
  # Boot configuration
  boot = {
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
  };
  # Localization settings
  localization = {
    console.font = "Lat2-Terminus16";
    console.keyMap = "de-latin1";
    i18n.defaultLocale = "en_US.UTF-8";
    time.timeZone = "Europe/Berlin";
  };
  # Network configuration
  networking = {
    networking.hostName = "nas";
    # Configure network connections interactively with nmcli or nmtui.
    networking.networkmanager.enable = true;
  };
  # NixOS settings
  nixos = {
    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
    system.stateVersion = "25.11";
  };
  # Users and groups
  users = {
    users.users.nas = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
    };
  };
in
lib.mkMerge [
  boot
  localization
  networking
  nixos
  users
]
