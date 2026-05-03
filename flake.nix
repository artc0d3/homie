{
  description = "Homie: A friendly home NAS server";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, home-manager, ... }:
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hardware.nix
          ./home-manager.nix
          ./services/avahi.nix
          ./services/jellyfin.nix
          ./services/samba.nix
          ./services/sshd.nix
          ./storage.nix
          ./system.nix
          home-manager.nixosModules.home-manager
        ];
      };
    };
}
