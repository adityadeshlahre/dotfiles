#############################
#              __
#  ____  _____/ /_  __________
# /_  / / ___/ __ \/ ___/ ___/
#  / /_(__  ) / / / /  / /__
# /___/____/_/ /_/_/   \___/
##############################

# .zshenv -> .zprofile -> .zshrc -> .zlogin
#
# Interactive shell config


# Shared history across sessions
setopt share_history
# Vim mode & faster key timeout
bindkey -v
KEYTIMEOUT=1
# By default, Normal mode -> / is search
bindkey '^R' history-incremental-search-backward
# C-x C-e to edit the command int $EDITOR
autoload -z edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line


# ##### Git Information #####
# autoload -Uz vcs_info
#
# zstyle ':vcs_info:*' enable git
# # Hook before every commands
# precmd_vcs_info() { vcs_info }
# precmd_functions+=( precmd_vcs_info )
# setopt prompt_subst
#
# zstyle ':vcs_info:*' check-for-changes true
#
# zstyle ':vcs_info:*' unstagedstr '*'
# zstyle ':vcs_info:*' stagedstr '+'
# zstyle ':vcs_info:git:*' formats '%b%u%c'
# # Only displayed in Git action like rebase, merge, cherry-pick
# zstyle ':vcs_info:git:*' actionformats '[%b | %a%u%c]'


##### Vim mode indicator & cursor #####
# Cursor: https://unix.stackexchange.com/questions/433273/changing-cursor-style-based-on-mode-in-both-zsh-and-vim
# prompt: https://superuser.com/questions/151803/how-do-i-customize-zshs-vim-mode
# perform parameter expansion/command substitution in prompt
setopt PROMPT_SUBST

ins_mode_indicator="%F{black}%K{green} I %k%f"
ins_mode_cursor="\e[6 q"        # steady bar, 5 for blinking bar
norm_mode_indicator="%F{black}%K{cyan} N %k%f"
norm_mode_cursor="\e[2 q"       # steady block, 1 for blinking block (default)
# Initial mode
vi_mode_indicator=$ins_mode_indicator
cursor=$ins_mode_indicator

# Reset to [I] cursor before each command
# imo, this is better than modifying the `precmd_functions` array
# since we take care of the line editor issues within the ZLE itself
# Without this: the cursor is block upon terminal launch
zle-line-init() {
    echo -ne "$ins_mode_cursor"
}
zle -N zle-line-init

# On keymap change, redraw the prompt
zle-keymap-select() {
  if [[ "$KEYMAP" == 'vicmd' ]]; then
    vi_mode_indicator=$norm_mode_indicator
    echo -ne "$norm_mode_cursor"
  else
    vi_mode_indicator=$ins_mode_indicator
    echo -ne "$ins_mode_cursor"
  fi
  zle reset-prompt
}
zle -N zle-keymap-select

# Reset to [I] after the input reading
# Without this: RET in [N] makes the next prompt [N] even though it is [I]
zle-line-finish() {
  vi_mode_indicator=$ins_mode_indicator
}
zle -N zle-line-finish

# Catch SIGNIT and set the prompt to int again, and resend SIGINT
# Without this: C-c in [N] makes the next prompt [N] even though it is [I]
TRAPINT() {
  vi_mode_indicator=$ins_mode_indicator
  return $(( 128 + $1 ))
}


##### PROMPT #####

# %(5~|%-1~/…/%3~|%4~) - IF path_len > 5 THEN print 1st element; print /.../; print last 3 elem; ELSE print 4 elem;
PROMPT="%B\
\$vi_mode_indicator\
%F{cyan}%K{black} %(5~|%-1~/.../%3~|%4~) %k%f\
%F{black}%K{blue} \$vcs_info_msg_0_ %k%f\
%F{white} ❱ %f\
%b"

RPROMPT="%(?|%K{green}%F{black}|%K{red}%F{white})%B %? %b%f%k"


##### Alias #####
alias cl='clear'

alias ga='git add'
alias gcm='git commit -m'
alias gss='git status'

alias histgrep='echo "[Tip] Use !number to execute the command" && history -i | grep'

alias nv='neovide --fork'
alias v=nvim
alias l='eza --color=auto --icons=auto  --long --all --header --time-style=long-iso'


##### Functions #####
mkcd() { mkdir -p $1; cd $1 }

numfiles() {
  num=$(ls -A $1 | wc -l)
  echo "$num files in $1"
}

# c for archive, z for gzip, v for verbose, f for file
tarmake() { tar -czvf ${1}.tar.gz $1 }

# x for extracting, v for verbose, f for file
tarunmake() { tar -zxvf $1 }


##### Simple Trash Function #####
function trash() {
  if [[ -z "$THEOSHELL_TRASH_DIR" ]]; then
    echo "You must provide THEOSHELL_TRASH_DIR"
    return 1
  fi

  [[ ! -d ${THEOSHELL_TRASH_DIR} ]] && mkdir -p ${THEOSHELL_TRASH_DIR}

  if [[ -z $@ ]]; then
    echo 'Select file(s) to trash!'
    return 2
  fi

  for file in "$@"; do
    mv "$file" "$THEOSHELL_TRASH_DIR" && echo ":) $file moved to trash!" || echo ":( Failed to move $file to trash"
  done
}


##### Minimal Plugin Manager #####

# Double check double check
function source_file() {
  [ -f ${ZSH_PLUGIN_DIR}/$1 ] && source ${ZSH_PLUGIN_DIR}/$1
}

# Function to source or load a plugin
function plug() {
  if [[ -z "$ZSH_PLUGIN_DIR" ]]; then
    echo "You must provide ZSH_PLUGIN_DIR"
    return 1
  fi

  PLUGIN_NAME=$(echo $1 | cut -d "/" -f 2)
  if [[ -d ${ZSH_PLUGIN_DIR}/${PLUGIN_NAME} ]]; then
    source_file ${PLUGIN_NAME}/${PLUGIN_NAME}.plugin.zsh || \
    source_file ${PLUGIN_NAME}/${PLUGIN_NAME}.zsh
  else
    git clone --depth 1 "https://github.com/${1}.git" ${ZSH_PLUGIN_DIR}/${PLUGIN_NAME}
  fi
}

function plug_update() {
  if [[ -z "$ZSH_PLUGIN_DIR" ]]; then
    echo "You must provide ZSH_PLUGIN_DIR"
    return 1
  fi

  for repo in ${ZSH_PLUGIN_DIR}/*
  do
    echo "refreshing ${repo}:"
    cd ${repo} && git pull && cd - > /dev/null
  done
}

# Add zsh-autocomplete
# plug marlonrichert/zsh-autocomplete
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh


##### External Tools #####
if (( $+commands[fd] )); then
  export FZF_DEFAULT_COMMAND='fd --hidden --strip-cwd-prefix --exclude ".git"'
fi
export FZF_DEFAULT_OPTS='--layout=reverse --cycle --height=50% --margin=5% --border=double'

if (( $+commands[fzf] )); then
  source <(fzf --zsh)
fi

if (( $+commands[zoxide] )); then
  eval "$(zoxide init zsh --cmd c)"
fi



# Personal additions

##### Directory Bookmark using FZF #####
cdf() {
  if [[ -z "$THEOSHELL_CDF_DIR" ]]; then
    echo "You must provide THEOSHELL_CDF_DIR"
    return 1
  fi
  dir=$(fzf --header="Favorite Directories" < $THEOSHELL_CDF_DIR)
  [[ ! -z "$dir" ]] && cd "$dir"
}

cdf_add() {
  if [[ -z "$THEOSHELL_CDF_DIR" ]]; then
    echo "You must provide THEOSHELL_CDF_DIR"
    return 1
  fi
  if [[ ! -e $THEOSHELL_CDF_DIR ]]; then
    mkdir -p $(dirname $THEOSHELL_CDF_DIR)
    touch $THEOSHELL_CDF_DIR
  fi
  pwd >> $THEOSHELL_CDF_DIR
}
alias cdf_edit="$EDITOR $THEOSHELL_CDF_DIR"


##### Git Information #####
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
setopt prompt_subst
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr '*'
zstyle ':vcs_info:*' stagedstr '+'
zstyle ':vcs_info:git:*' formats '%b%u%c'
zstyle ':vcs_info:git:*' actionformats '[%b | %a%u%c]'
precmd() {
  if git rev-parse --is-inside-work-tree &>/dev/null; then
    vcs_info
  fi
}


##### PROMPT #####
setopt PROMPT_SUBST
ins_mode_indicator="%F{yellow}[I]%f"
norm_mode_indicator="%F{magenta}[N]%f"
vi_mode_indicator=$ins_mode_indicator

zle-keymap-select() {
  if [[ "$KEYMAP" == 'vicmd' ]]; then
    vi_mode_indicator=$norm_mode_indicator
  else
    vi_mode_indicator=$ins_mode_indicator
  fi
  zle reset-prompt
}
zle -N zle-keymap-select

zle-line-finish() {
  vi_mode_indicator=$ins_mode_indicator
}
zle -N zle-line-finish

TRAPINT() {
  vi_mode_indicator=$ins_mode_indicator
  return $(( 128 + $1 ))
}

PROMPT=" \$vi_mode_indicator %F{magenta}%n@%m%f %F{blue}%(5~|%-1~/.../%3~|%4~)%f %F{cyan}\$vcs_info_msg_0_%f %F{white}❱%f "
RPROMPT="%(?|%F{green}|%F{red})[%?]%f "


##### Greeting #####
function zsh_greeting() {
  normal='\033[0m'
  red='\033[0;31m'; brred='\033[1;31m'
  green='\033[0;32m'; brgreen='\033[1;32m'
  yellow='\033[0;33m'; bryellow='\033[1;33m'
  blue='\033[0;34m'; brblue='\033[1;34m'
  magenta='\033[0;35m'; brmagenta='\033[1;35m'
  cyan='\033[0;36m'; brcyan='\033[1;36m'

  olivers=(
    ' \/   \/; |\__/,|     _; _.|o o  |_   ) ); -(((---(((--------' \
    ' |\      _-``---,) ); ZZZzz /,`.-```    -.   /; |,4-  ) )-,_. ,\ (; `---``(_/--`  `-`\_)' \
    ' \/   \/; |\__/,|        _; |_ _  |.-----.) ); ( T   ))        ); (((^_(((/___(((_/' \
  )
  oliver=${olivers[ $(( RANDOM % ${#olivers[@]} + 1 )) ]}
  zsh_ver="$(zsh --version)"
  uptime=$(uptime | grep -ohe 'up .*' | sed 's/,//g' | awk '{ print $2" "$3 " " }')

  echo
  echo -e "  " "$brgreen" "Meow"                             "$normal"
  echo -e "  " "$brred"   "$oliver"                          "$normal"
  echo -e "  " "$cyan"    "  Shell:\t"   "$brcyan$zsh_ver"  "$normal"
  echo -e "  " "$blue"    "  Uptime:\t"  "$brblue$uptime"   "$normal"
  echo
}
zsh_greeting


# gvm
export GVM_DIR="$HOME/.gvm"
gvm() { unset -f gvm go; source "$GVM_DIR/scripts/gvm"; gvm "$@" }
go() { unset -f gvm go; source "$GVM_DIR/scripts/gvm"; go "$@" }

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
pyenv() { unset -f pyenv; eval "$(command pyenv init -)"; pyenv "$@" }
pyenv-virtualenv() { unset -f pyenv-virtualenv; eval "$(pyenv virtualenv-init -)" }

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && source "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && source "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

export GPG_TTY=$(tty)
alias dockerps="docker ps"
export PATH="/Users/mumbo/.antigravity/antigravity/bin:$PATH"

# rvm
export RVM_DIR="$HOME/.rvm"
rvm() { unset -f rvm; source "$RVM_DIR/scripts/rvm"; rvm "$@" }

export LDFLAGS="-L/opt/homebrew/opt/openssl@1.1/lib -L/opt/homebrew/opt/readline/lib -L/opt/homebrew/opt/zlib/lib -L/opt/homebrew/opt/libyaml/lib"
export CPPFLAGS="-I/opt/homebrew/opt/openssl@1.1/include -I/opt/homebrew/opt/readline/include -I/opt/homebrew/opt/zlib/include -I/opt/homebrew/opt/libyaml/include"
export PKG_CONFIG_PATH="/opt/homebrew/opt/openssl@1.1/lib/pkgconfig"

export EDITOR="nvim"
export VISUAL="nvim"
