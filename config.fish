#-------------------------------------------------------------------------------
# Prompt
#-------------------------------------------------------------------------------

# Display the powerline on its own line
set -g theme_newline_cursor yes
set -g theme_newline_prompt "\$ "

# Add a newline before every prompt to space things out
functions --copy fish_prompt fish_prompt_original
function fish_prompt; echo; fish_prompt_original; end

# bobthefish theme
set -g theme_color_scheme dracula

# My color scheme
set -U fish_color_normal normal
set -U fish_color_command F8F8F2
set -U fish_color_quote F1FA8C
set -U fish_color_redirection 8BE9FD
set -U fish_color_end 50FA7B
set -U fish_color_error FF5555
set -U fish_color_param 5FFFFF
set -U fish_color_comment 6272A4
set -U fish_color_match --background=brblue
set -U fish_color_selection white --bold --background=brblack
set -U fish_color_search_match bryellow --background=brblack
set -U fish_color_history_current --bold
set -U fish_color_operator 00a6b2
set -U fish_color_escape 00a6b2
set -U fish_color_cwd green
set -U fish_color_cwd_root red
set -U fish_color_valid_path --underline
set -U fish_color_autosuggestion BD93F9
set -U fish_color_user brgreen
set -U fish_color_host normal
set -U fish_color_cancel -r
set -U fish_pager_color_completion normal
set -U fish_pager_color_description B3A06D yellow
set -U fish_pager_color_prefix white --bold --underline
set -U fish_pager_color_progress brwhite --background=cyan

# Override the nix prompt for the theme so that we show a more concise prompt
function __bobthefish_prompt_nix -S -d 'Display current nix environment'
    [ "$theme_display_nix" = 'no' -o -z "$IN_NIX_SHELL" ]
    and return

    __bobthefish_start_segment $color_nix
    echo -ns N ' '

    set_color normal
end


#-------------------------------------------------------------------------------
# Functions
#-------------------------------------------------------------------------------

# Shortcut to setup a nix-shell with fish. This lets you do something like
# `fnix -p go` to get an environment with Go but use the fish shell along
# with it.
alias fnix "nix-shell --run fish"
