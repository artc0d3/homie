# Cockpit is a web-based server management tool that allows you to manage your server through a web interface.
{ ... }:
{
  services.cockpit = {
    enable = true;
    port = 9090;
    openFirewall = true;
    settings = {
      WebService = {
        AllowUnencrypted = true;
      };
    };
  };
}
