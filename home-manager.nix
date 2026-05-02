{ config, pkgs, lib, ... }:
let
  homie-config = {
    home.stateVersion = "25.11";
    programs.git = {
      enable = true;
      signing.format = null;
    };
    programs.neovim = {
      enable = true;
      defaultEditor = true;
    };
    programs.starship = {
      enable = true;
      enableZshIntegration = true;
      settings = builtins.fromTOML (builtins.readFile ./configs/starship/settings.toml);
    };
    programs.zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" ];
      };
    };
  };
in
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.homie = homie-config;
  };
}
