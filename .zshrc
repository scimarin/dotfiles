export SERVER=0
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
    export EDITOR='vim'
else
    export EDITOR='nvim'
fi

HISTSIZE=1000000
SAVEHIST=1000000
HISTFILE=~/.zsh_history
DISABLE_CORRECTION="true"
setopt SHARE_HISTORY        # share history between sessions
setopt HIST_REDUCE_BLANKS   # remove useless blanks before commands

KEYTIMEOUT=1

# check for zplug
if [[ ! -d ~/.zplug  ]]; then
    git clone https://github.com/zplug/zplug ~/.zplug
    source ~/.zplug/init.zsh && zplug update --self
fi

source ~/.zplug/init.zsh

autoload -U compinit && compinit

zplug 'zplug/zplug', hook-build:'zplug --self-manage'
zplug 'zdharma/fast-syntax-highlighting', hook-load:'FAST_HIGHLIGHT=()', defer:2
zplug "b4b4r07/zsh-vimode-visual", defer:3
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-completions"
zplug "plugins/rust", from:oh-my-zsh
zplug "plugins/cargo", from:oh-my-zsh
zplug "plugins/fzf", from:oh-my-zsh
zplug "MichaelAquilina/zsh-you-should-use"
zplug "wfxr/forgit"
zplug "~/.zsh", from:local

# theme
eval "$(starship init zsh)"

# Install packages that have not been installed yet
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    else
        echo
    fi
fi

zplug load

# User configuration
export LANG=en_US.UTF-8

# Aliases
alias vim="nvim"
alias zshconfig="nvim ~/.zshrc"
alias readelf="readelf --all -W"
alias l="ls -CFhn --color=auto --group-directories-first"
alias ls="ls -CFhn --color=auto --group-directories-first"
alias ll="ls -alF --color=auto --group-directories-first"
alias la="ls -AFhNC --color=auto --group-directories-first"
alias rsync="rsync --info=progress2"
alias gl="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias gs="git status"
alias gm="git commit -m"
alias cat="bat --theme=zenburn"
alias find="fd"
alias python="/usr/bin/python3"
alias pip="/usr/bin/pip3"
alias glow="glow -p"
alias archivebox="docker-compose run archivebox"
alias lt='launchctl'

setopt hist_ignore_dups
setopt hist_reduce_blanks
setopt hist_ignore_space
setopt extended_history
setopt hist_expand
setopt share_history
setopt prompt_subst
unsetopt correct

bindkey -v
bindkey '^R' history-incremental-search-backward


zstyle ':completion:*' menu select
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="bold,underline"

fe() (
  exec < /dev/tty
  IFS=$'\n' files=($(fzf-tmux --query="$1" --multi --select-1 --exit-0))
  [[ -n "$files" ]] && ${EDITOR:-nvim} "${files[@]}"
)

zle -N fe
bindkey "^o" fe

export FZF_DEFAULT_COMMAND='rg --files --hidden --follow -g "!{.mozilla,*cache*,*Cache*,.node*,.electron*,.local,.steam,.cache,.git,Steam,Music,Videos}" 2> /dev/null'
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

LFCD="~/.config/lf/lfcd.sh"
if [ -f "$LFCD" ]; then
 source "$LFCD"
fi

# Open lf
source ~/.config/lf/lfcd.sh
bindkey -s "^\\" 'lfcd\n'

[ -f "${GHCUP_INSTALL_BASE_PREFIX:=$HOME}/.ghcup/env" ] && source "${GHCUP_INSTALL_BASE_PREFIX:=$HOME}/.ghcup/env"

source ~/.zshenv
