# $ fish figlet -f fourtops fish
#  /~\'  |
# -|- |(~|/~\
#  |  |_)|   |
#

abbr -a nv neovide --fork
abbr -a v nvim
abbr -a dockerps docker ps
abbr -a lg lazygit

# .. to cd .., ... to cd ../.., etc.
function multicd
    echo cd (string repeat -n (math (string length -- $argv[1]) - 1) ../)
end
abbr --add dotdot --regex '^\.\.+$' --function multicd


