# $figlet -f fuzzy fish
#  .--. _       .-.
# : .-':_;      : :
# : `; .-. .--. : `-.
# : :  : :`._-.': .. :
# :_;  :_;`.__.':_;:_;
#
# Mumbo's Fish config
# Most of them are in conf.d

if status is-interactive
  # Enable Vi keybinding
  fish_vi_key_bindings
  set fish_cursor_default block
  set fish_cursor_insert line
  set fish_vi_force_cursor
end

# fzf
if type -q fd
  set -gx FZF_DEFAULT_COMMAND 'fd --hidden --strip-cwd-prefix --exclude ".git"'
end
set -gx FZF_DEFAULT_OPTS '--layout=reverse --cycle --height=50% --margin=5% --border=double'

if type -q fzf
  fzf --fish | source
end


# zoxide
if type -q zoxide
  zoxide init fish --cmd c | source
end


set -gx MANPAGER "nvim +Man! +'set nocursorcolumn scrolloff=999'"
set -gx LESSHISTFILE '-'

set -q XDG_CACHE_HOME   ||  set -gx XDG_CACHE_HOME   "$HOME/.cache"
set -q XDG_CONFIG_HOME  ||  set -gx XDG_CONFIG_HOME  "$HOME/.config"
set -q XDG_DATA_HOME    ||  set -gx XDG_DATA_HOME    "$HOME/.local/share"
set -q XDG_STATE_HOME   ||  set -gx XDG_STATE_HOME   "$HOME/.local/state"

set -gx THEOSHELL_TRASH_DIR "$XDG_DATA_HOME/theoshell/trash"
set -gx THEOSHELL_CDF_DIR "$XDG_DATA_HOME/theoshell/cd-fav.txt"

fish_add_path ~/.local/bin


## Personal additions

set -x GPG_TTY (tty)

# pyenv
set -x PYENV_ROOT $HOME/.pyenv
if test -d $PYENV_ROOT/bin
  set -x PATH $PYENV_ROOT/bin $PATH
end
if status --is-interactive
  pyenv init - | source
  pyenv virtualenv-init - | source
end

# nvm
function nvm
  bass source ~/.nvm/nvm.sh --no-use ';' nvm $argv
end

# Java
set -x JAVA21_HOME /opt/homebrew/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home
set -x JAVA_HOME $JAVA21_HOME
fish_add_path $JAVA_HOME/bin

function use-java21
  set -x JAVA_HOME $JAVA21_HOME
  set -x PATH $JAVA_HOME/bin $PATH
  echo "Switched to Java 21"
end

# RVM
function rvm
  bass source $HOME/.rvm/scripts/rvm ';' rvm $argv
end

set -x LDFLAGS "-L/opt/homebrew/opt/openssl@1.1/lib -L/opt/homebrew/opt/readline/lib -L/opt/homebrew/opt/zlib/lib -L/opt/homebrew/opt/libyaml/lib"
set -x CPPFLAGS "-I/opt/homebrew/opt/openssl@1.1/include -I/opt/homebrew/opt/readline/include -I/opt/homebrew/opt/zlib/include -I/opt/homebrew/opt/libyaml/include"
set -x PKG_CONFIG_PATH "/opt/homebrew/opt/openssl@1.1/lib/pkgconfig"

set -Ux EDITOR nvim
set -Ux VISUAL nvim
