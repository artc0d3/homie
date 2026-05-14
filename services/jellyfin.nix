# Jellyfin media server
#
# Media directories under /data (e.g. /data/movies, /data/music) should be
# readable by the jellyfin user. The web UI is available on port 8096.
{ ... }:
{
  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };

  # Grant jellyfin traverse access to the /data mount point and
  # read access to media directories via ACL
  systemd.tmpfiles.rules = [
    "A+ /data - - - - user:jellyfin:r-x"
    "A+ /data/music - - - - user:jellyfin:r-x"
    "A+ /data/music - - - - default:user:jellyfin:r-x"
    "A+ /data/video - - - - user:jellyfin:r-x"
    "A+ /data/video - - - - default:user:jellyfin:r-x"
  ];
}
