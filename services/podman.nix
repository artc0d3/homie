{
  config,
  lib,
  pkgs,
  ...
}:
{
  virtualisation = {
    containers.enable = true;
    oci-containers.backend = "podman";

    podman = {
      enable = true;
      dockerCompat = true; # Alias `docker` to `podman` for compatibility.

      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  # Useful other development tools
  environment.systemPackages = with pkgs; [
    podman-tui # Status of containers in the terminal
    podman-compose # Start group of containers for dev
  ];
}
