#-------------------------------------------------------------------------------
# Programs
#-------------------------------------------------------------------------------

# Cursor
if test -d "/Applications/Cursor.app"
    set -q PATH; or set PATH ''; set -gx PATH "/Applications/Cursor.app/Contents/Resources/app/bin" $PATH;
end

#-------------------------------------------------------------------------------
# Prompt
#-------------------------------------------------------------------------------

# Tide: show cwd at prompt, process name otherwise (for Ghostty tab titles)
function fish_title
    if test (status current-command) = fish
        prompt_pwd
    else
        status current-command
    end
end


#-------------------------------------------------------------------------------
# Functions
#-------------------------------------------------------------------------------

# Shortcut to setup a nix-shell with fish. This lets you do something like
# `fnix -p go` to get an environment with Go but use the fish shell along
# with it.
alias fnix "nix-shell --run fish"
alias hms "home-manager switch --flake ~/git/justinrosenthal/nix-home"

function mvtmp -d 'Move files to ~/tmp/backup/<date>'
    set -l datedir ~/tmp/backup/(date +%Y%m%d)
    mkdir -p $datedir
    mv $argv $datedir
end
