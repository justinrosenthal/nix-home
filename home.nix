{ config, pkgs, ... }:

{
  programs.home-manager.enable = true;
  home.username = "justin";
  home.homeDirectory = "/Users/justin";
  home.stateVersion = "21.11";

  home.packages = with pkgs; [
    ack
    any-nix-shell
    direnv
    fzf
    go_1_17
    gopls
    jq
    ripgrep
    tree
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
      env.PATH = builtins.replaceStrings ["\n"] [":"] (builtins.readFile /etc/paths);
      shell.program = "/Users/justin/.nix-profile/bin/fish";

      window.padding = {
        x = 5;
        y = 5;
      };

      font = {
        size = 13;
        normal.family = "Monaco for Powerline";
      };

      key_bindings = [
        { key = "V"; mods = "Command"; action = "Paste"; }
        { key = "C"; mods = "Command"; action = "Copy"; }
        { key = "N"; mods = "Command"; action = "CreateNewWindow"; }
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

      {
        name = "plugin-foreign-env";
        src = pkgs.fetchFromGitHub {
          owner = "oh-my-fish";
          repo = "plugin-foreign-env";
          rev = "dddd9213272a0ab848d474d0cbde12ad034e65bc";
          sha256 = "00xqlyl3lffc5l0viin1nyp819wf81fncqyz87jx8ljjdhilmgbs";
        };
      }

      {
        name = "fish-fzf";
        src = pkgs.fetchFromGitHub {
          owner = "jethrokuan";
          repo = "fzf";
          rev = "24f4739fc1dffafcc0da3ccfbbd14d9c7d31827a";
          sha256 = "0kz057nr07ybh0y06ww3p424rgk8pi84pnch9jzb040qqn9a8823";
        };
      }
    ];

    shellInit = ''
      # Setup the Nix environment (conditional because it's non-idempotent)
      if not type -q nix
        fenv source '~/.nix-profile/etc/profile.d/nix.sh'
      end

      # Activate any-nix-shell so `nix-shell` loads fish instead of bash
      any-nix-shell fish | source

      # Activate direnv
      direnv hook fish | source
    '';

    interactiveShellInit = builtins.readFile ./config.fish;

    shellAliases = {
      vi = "~/.nix-profile/bin/vim";
      vim = "~/.nix-profile/bin/vim";

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

    delta = {
      enable = true;
      options = {
        line-numbers = true;
        navigate = true;
      };
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
    keyMode = "vi";

    plugins = with pkgs.tmuxPlugins; [
      {
        plugin = dracula;
        extraConfig = ''
          set -g @dracula-plugins "time"
          set -g @dracula-show-powerline true
          set -g @dracula-refresh-rate 1
        '';
      }
    ];

    extraConfig = ''
      set -g default-command fish
      set -g default-terminal "xterm-256color"
      set-option -ga terminal-overrides ",xterm-256color:Tc"
      set -g mouse on
    '';
  };

  programs.vim = {
    enable = true;

    plugins = with pkgs.vimPlugins; [
      auto-pairs
      vim-go
      vim-terraform
      dracula-vim
    ];

    extraConfig = builtins.readFile ./vimrc;
  };
}
