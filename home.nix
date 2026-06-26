{ config, lib, pkgs, claude-code, ... }:

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
    claude-code
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

  # Apply the tide prompt config. Tide stores its settings as fish *universal*
  # variables, and its async prompt renders in a background `fish -c`
  # subprocess that only sees universal vars (globals/exports don't survive the
  # process boundary, and exports mangle list vars). home-manager symlinks the
  # tide plugin but never fires its `_tide_init_install` event, so we set the
  # universals ourselves on each rebuild from the committed config. tide's
  # autoloaded fish_prompt then computes the per-host item lists at first prompt.
  #
  # Regenerate tide-config.fish after running `tide configure`, with:
  #   for v in (set -nU | string match 'tide_*')
  #       echo set -U $v (string escape -- $$v)
  #   end > tide-config.fish
  # --no-config so this activation-time fish doesn't source config.fish (whose
  # interactive shellInit calls any-nix-shell/direnv, which aren't on PATH
  # during activation). We only need it to set tide's universal variables.
  home.activation.tideConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run ${pkgs.fish}/bin/fish --no-config -c 'source ${./tide-config.fish}'
  '';

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.mise = {
    enable = true;
    # enableFishIntegration defaults to true, wiring up `mise activate fish`.
  };

  programs.fzf = {
    enable = true;
    defaultOptions = [ "--layout=reverse" "--height=35%" ];
  };

  programs.fish = {
    enable = true;

    plugins = with pkgs.fishPlugins; [
      { name = "tide"; src = tide.src; }
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

      # Strip Nix's .foo-wrapped naming from automatic window titles
      set-option -g automatic-rename-format '#{s/^\.//:#{s/-wrapped$//:pane_current_command}}'
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
