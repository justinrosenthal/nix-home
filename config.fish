#-------------------------------------------------------------------------------
# Environment
#-------------------------------------------------------------------------------
set -x FZF_DEFAULT_OPTS '--layout=reverse --height=35%'

#-------------------------------------------------------------------------------
# Prompt
#-------------------------------------------------------------------------------

# Display the powerline on its own line
set -g theme_newline_cursor yes
set -g theme_newline_prompt "\$ "

# Add a newline before every prompt to space things out
functions --copy fish_prompt fish_prompt_original
function fish_prompt; echo; fish_prompt_original; end

# Enable k8s context segment
set -g theme_display_k8s_context yes

# bobthefish theme
function bobthefish_colors -S -d 'Define a custom bobthefish color scheme'
    # Inherit from the dracula theme
    __bobthefish_colors dracula

    # These were copied from __bobthefish_colors.fish
    set -l bg       282a36
    set -l green    50fa7b

    # Better legibility for the k8s context segment
    set -x color_k8s $green $bg --bold
end

# Override the nix prompt for the theme so that we show a more concise prompt
function __bobthefish_prompt_nix -S -d 'Display current nix environment'
    [ "$theme_display_nix" = 'no' -o -z "$IN_NIX_SHELL" ]
    and return

    __bobthefish_start_segment $color_nix
    echo -ns N ' '

    set_color normal
end

# Show the current git user's name if it's different from the global config
functions --copy __bobthefish_git_branch __bobthefish_git_branch_original
function __bobthefish_git_branch
    __bobthefish_git_branch_original

    set -l git_user_name (command git config user.name)
    set -l git_global_user_name (command git config --global user.name)
    if [ $git_user_name != $git_global_user_name ]
        echo -n " [$git_user_name]"
    end
end


#-------------------------------------------------------------------------------
# Functions
#-------------------------------------------------------------------------------

# Shortcut to setup a nix-shell with fish. This lets you do something like
# `fnix -p go` to get an environment with Go but use the fish shell along
# with it.
alias fnix "nix-shell --run fish"

function mvtmp -d 'Move files to ~/tmp/backup/<date>'
    set -l datedir ~/tmp/backup/(date +%Y%m%d)
    mkdir -p $datedir
    mv $argv $datedir
end
