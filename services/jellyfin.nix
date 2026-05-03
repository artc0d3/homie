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
}
