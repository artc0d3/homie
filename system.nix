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
    networking.hostName = "homie";
    # Configure network connections interactively with nmcli or nmtui.
    networking.networkmanager.enable = true;

    # Firewall settings
    networking.nftables.enable = true;
    networking.firewall = {
      enable = true;

      # Drop all incoming ICMP except rate-limited ping (handled below).
      allowPing = true;
      pingLimit = "1/second burst 4 packets";
    };
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
    programs.zsh.enable = true;
    users.users.homie = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      hashedPasswordFile = config.sops.secrets."sys.user.homie".path;
      shell = pkgs.zsh;
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
