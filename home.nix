{ config, pkgs, pkgsUnstable, ... }:

let
  customVimPlugins = import ./vim-plugins.nix { inherit pkgs; };
in
{
  programs.home-manager.enable = true;
  home.username = "justin";
  home.homeDirectory = "/Users/justin";
  home.stateVersion = "23.05";

  home.packages = with pkgs; [
    ack
    any-nix-shell
    pkgsUnstable.claude-code
    gh
    go
    gopls
    httpie
    jq
    kubectx
    ripgrep
    stern
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

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.fzf = {
    enable = true;
    defaultOptions = [ "--layout=reverse" "--height=35%" ];
  };

  programs.fish = {
    enable = true;

    plugins = with pkgs.fishPlugins; [
      { name = "bobthefish"; src = bobthefish.src; }
      { name = "foreign-env"; src = foreign-env.src; }
      { name = "fzf"; src = fzf.src; }
    ];

    shellInit = ''
      # Setup the Nix environment (conditional because it's non-idempotent)
      if not type -q nix
        fenv source '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
        fenv source '/nix/var/nix/profiles/default/etc/profile.d/nix.sh'
      end

      # Activate any-nix-shell so `nix-shell` loads fish instead of bash
      any-nix-shell fish | source

      # Activate direnv
      direnv hook fish | source
    '';

    interactiveShellInit = builtins.readFile ./config.fish;

    shellAliases = {
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

    settings = {
      user.name = "Justin Rosenthal";
      user.email = "justin.rosenthal@gmail.com";

      alias.prettylog = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(r) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";

      branch.autosetuprebase = "always";
      color.ui = true;
      push.default = "upstream";
      init.defaultBranch = "main";
    };

    ignores = [
      ".DS_Store"
      "*~"
      "*.swp"
    ];
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      line-numbers = true;
      navigate = true;
    };
  };

  programs.tmux = {
    enable = true;

    terminal = "tmux-256color";
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
      set-option -ga terminal-overrides ",*:Tc"
      set -g mouse on
    '';
  };

  programs.vim = {
    enable = true;

    plugins = with pkgs.vimPlugins; with customVimPlugins; [
      auto-pairs
      vim-go
      vim-javascript
      vim-misc
      vim-terraform
      dracula-vim
    ];

    extraConfig = builtins.readFile ./vimrc;
  };
}
