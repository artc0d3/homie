{
  config,
  pkgs,
  lib,
  ...
}:
let
  homie-config = {
    home.stateVersion = "25.11";
    home.packages = with pkgs; [
      fd
      jq
      nixfmt
      ripgrep
      sd
      vfox
    ];
    programs.bat.enable = true;
    programs.eza = {
      enable = true;
      enableZshIntegration = true;
      git = true;
      icons = "auto";
    };
    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
      defaultCommand = "fd --type f --hidden --exclude .git";
    };
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
    programs.uv = {
      enable = true;
    };
    programs.zoxide = {
      enable = true;
      options = [ "--cmd cd" ];
    };
    programs.zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" ];
      };
      initContent = ''
        eval "$(vfox activate zsh)"
      '';
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
