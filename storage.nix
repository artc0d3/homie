# BTRFS RAID1 storage configuration
#
# Before first boot, create the filesystem manually:
#   mkfs.btrfs -m raid1 -d raid1 -L homie /dev/disk/by-id/DISK1 /dev/disk/by-id/DISK2
#
# Replace DISK1 and DISK2 below with your actual disk identifiers.
# Find them with: lsblk
{ pkgs, ... }:
{
  users.groups.storage = { };
  users.users.homie.extraGroups = [ "storage" ];

  environment.systemPackages = with pkgs; [
    acl
    btrfs-progs
  ];

  # Scan for multi-device BTRFS volumes before mounting
  boot.initrd.supportedFilesystems = [ "btrfs" ];

  fileSystems."/data" = {
    device = "/dev/disk/by-label/homie";
    fsType = "btrfs";
    options = [
      "compress=zstd"
      "noatime"
      "nofail"
    ];
  };

  # Set group ownership and permissions on /data (setgid ensures new files inherit the storage group)
  systemd.tmpfiles.rules = [
    "d /data 2770 homie storage -"
    "d /data/music - homie storage -"
    "d /data/video - homie storage -"
  ];

  services.btrfs.autoScrub = {
    enable = true;
    fileSystems = [ "/data" ];
    interval = "monthly";
  };
}
