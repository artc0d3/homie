{ config, pkgs, ... }:
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
