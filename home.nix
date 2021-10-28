{ config, pkgs, ... }:

{
  programs.home-manager.enable = true;
  home.username = "justin";
  home.homeDirectory = "/Users/justin";
  home.stateVersion = "21.11";

  home.packages = [
    pkgs.ack
    pkgs.jq
    pkgs.tree
  ];

  home.sessionVariables = {
    LANG = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    EDITOR = "vim";
    PAGER = "less -FirSwX";
    MANPAGER = "less -FirSwX";
  };

  programs.alacritty = {
    enable = true;

    settings = {
      env.TERM = "xterm-256color";
      shell.program = "/Users/justin/.nix-profile/bin/fish";

      window.padding = {
        x = 5;
        y = 5;
      };

      font = {
        size = 11;
        normal.family = "Monaco for Powerline";
      };

      key_bindings = [
        { key = "V"; mods = "Command"; action = "Paste"; }
        { key = "C"; mods = "Command"; action = "Copy"; }
        { key = "Key0"; mods = "Command"; action = "ResetFontSize"; }
        { key = "Plus"; mods = "Command"; action = "IncreaseFontSize"; }
        { key = "Minus"; mods = "Command"; action = "DecreaseFontSize"; }
      ];
    };
  };

  programs.fish = {
    enable = true;

    plugins = [
      {
        name = "theme-bobthefish";
        src = pkgs.fetchFromGitHub {
          owner = "oh-my-fish";
          repo = "theme-bobthefish";
          rev = "626bd39b002535d69e56adba5b58a1060cfb6d7b";
          sha256 = "06whihwk7cpyi3bxvvh3qqbd5560rknm88psrajvj7308slf0jfd";
        };
      }
    ];

	interactiveShellInit = builtins.readFile ./config.fish;

    shellAliases = {
      vi = "vim";

      ga = "git add";
      gb = "git branch";
      gc = "git commit";
      gco = "git checkout";
      gd = "git diff";
      gdc = "git diff --cached";
      glog = "git prettylog";
      gs = "git status";
    };
  };

  programs.git = {
    enable = true;

    userName = "Justin Rosenthal";
    userEmail = "justin.rosenthal@gmail.com";

    aliases = {
      prettylog = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(r) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
    };

    extraConfig = {
      branch.autosetuprebase = "always";
      color.ui = true;
      push.default = "tracking";
      init.defaultBranch = "main";
    };

    ignores = [
      ".DS_Store"
      "*~"
      "*.swp"
    ];
  };

  programs.tmux = {
    enable = true;

    terminal = "xterm-256color";
    secureSocket = false;

    extraConfig = ''
      set -g default-terminal "xterm-256color"
      set-option -ga terminal-overrides ",xterm-256color:Tc"
    '';
  };

  programs.vim = {
    enable = true;

    plugins = with pkgs.vimPlugins; [
      vim-go
      vim-terraform
      dracula-vim
    ];

	extraConfig = builtins.readFile ./vimrc;
  };
}
