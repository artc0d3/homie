# Avahi/zeroconf for mDNS discovery (homie.local)
{ ... }:
{
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
    publish = {
      enable = true;
      addresses = true;
      workstation = false;
    };
  };
}
