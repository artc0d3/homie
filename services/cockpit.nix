# Cockpit is a web-based server management tool that allows you to manage your server through a web interface.
{ pkgs, ... }:
{
  services.cockpit = {
    enable = true;
    port = 9090;
    openFirewall = true;
    allowed-origins = [ "http://homie.local:9090" ];
    settings = {
      WebService = {
        AllowUnencrypted = true;
      };
    };
  };

  # Required for Cockpit's storage management plugin.
  services.udisks2.enable = true;
}
