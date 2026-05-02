# NixOS module that runs ddclient as a systemd service to keep a Cloudflare A record pointed at the host's current
# public IPv4 address. Checks every 5 minutes.
#
# Setup
# -----
# 1. Create a Cloudflare API token at
#      https://dash.cloudflare.com/profile/api-tokens
#    Use the "Edit zone DNS" template, scope it to your specific zone.
#    Required permissions: Zone:DNS:Edit and Zone:Zone:Read.
# 2. Make sure the A record you want to update already exists in Cloudflare.
#    ddclient updates existing records — it will not create new ones.
# 3. Save the token safely:
#    read token && echo "$token" | sudo install -m 0600 /dev/stdin /var/lib/secrets/cloudflare-ddns.token
# 4. Edit the `zone` and `domains` values below for your domain.
#
# Verify:
# -----
# To check the status: systemctl status ddclient
# To check the logs: journalctl -u ddclient -n 50

{ ... }:
{
  services.ddclient = {
    enable = true;
    interval = "5min";
    protocol = "cloudflare";

    username = "token"; # Fixed value when using API tokens, don't change.
    passwordFile = "/var/lib/secrets/cloudflare-ddns.token"; # Path to the token file you created in step 3 above.

    zone = "miauz.eu";
    domains = [ "miauz.eu" "www.miauz.eu" "*.miauz.eu" ];
    ssl = true;
    usev4 = "";
    usev6 = "webv6";

    extraConfig = ''
      webv6=https://cloudflare.com/cdn-cgi/trace
      webv6-skip=ip=
    '';
  };
}
