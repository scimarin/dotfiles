export SERVER=0
export LANG=en_US.UTF-8

# preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
    export EDITOR='vim'
else
    export EDITOR='nvim'
fi

HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
DISABLE_CORRECTION="true"

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

# install packages that have not been installed yet
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    else
        echo
    fi
fi

zplug load

# aliases
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
alias gp="git push"
alias dropdown="kitty -T dropdown_term &"
alias cat="bat --theme=zenburn --wrap character"
alias find="fd"
alias cloud="ssh smoothlife@hetzner -p 32349"
alias glow="glow -p"
alias archivebox="docker-compose run archivebox"

setopt hist_ignore_dups
setopt hist_reduce_blanks
setopt hist_ignore_space
setopt extended_history
setopt hist_expand
setopt share_history
setopt prompt_subst
unsetopt correct

zstyle ':completion:*' menu select
bindkey '^ ' autosuggest-accept
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="bold,underline"

# trigger fuzzy finder on <c-o>
fe() (
    exec < /dev/tty
    IFS=$'\n' files=($(fzf-tmux --query="$1" --multi --select-1 --exit-0))
    [[ -n "$files" ]] && ${EDITOR:-nvim} "${files[@]}"
)

zle -N fe
bindkey "^o" fe

export FZF_DEFAULT_COMMAND='rg --files --hidden --follow -g "!{.mozilla,*cache*,*Cache*,.node*,.electron*,.local,.steam,.cache,.git,Steam,Music,Videos}" 2> /dev/null'
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# trigger lf terminal file manager on <c-\>
LFCD="~/.config/lf/lfcd.sh"
if [ -f "$LFCD" ]; then
 source "$LFCD"
fi

# open lf
source ~/.config/lf/lfcd.sh
bindkey -s "^\\" 'lfcd\n'
