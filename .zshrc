# m2hq.net Common ~/.zshrc

export LANG=ja_JP.UTF-8

alias less=lv

autoload colors
colors

case "${OSTYPE}" in
freebsd*)
    alias ls="ls -G -w"
    alias vi=vim
    export EDITOR=/usr/local/bin/vim
    #export PAGER=/usr/local/bin/lv
    export PAGER=less
    hostname=`hostname`
    ;;
linux*)
    alias ls="ls --color"
    export EDITOR=/usr/bin/vim
    #export PAGER=/usr/bin/lv
    export PAGER=less
    hostname=`hostname --fqdn`
    ;;
esac

# per host settings
case `hostname` in
scarface)
    promptcolor=green
    promptcolor2=blue
    export GOPATH=$HOME/.go
    export PATH=$PATH:$HOME/.local/bin:$HOME/.local/opt/julius/bin:$HOME/.gem/ruby/1.9.1/bin:$GOPATH/bin
    export SVKLOGLEVEL=
    ;;
geopelia)
    promptcolor=magenta
    promptcolor2=red
    export PATH=$PATH:$HOME/.local/bin
    ;;
orcinus)
    promptcolor=blue
    promptcolor2=cyan
    export PATH=$PATH:$HOME/.local/bin
    ;;
ghosteye)
    unalias less
    alias vi=vim
    ;;
ouroboros)
    unalias less
    export PATH=$PATH:$HOME/.local/bin
    promptcolor=yellow
    promptcolor2=green
    ;;
pixy)
    unalias less
    export PATH=$PATH:$HOME/.local/bin
    promptcolor=cyan
    promptcolor2=blue
    ;;
*)
    unalias less
    promptcolor=white
    promptcolor2=white
    ;;
esac

case ${UID} in
0)
    LANG=C
    PROMPT="%B${fg[red]}[%n@${hostname}${fg[default]}:%~]${fg[default]}
%T %B%#%b "
    ;;
*)
    PROMPT="%B${fg[${promptcolor2}]}[${fg[${promptcolor}]}%n@${hostname}${fg[default]}:%~${fg[${promptcolor2}]}]${fg[default]}%b
%T %B%#%b "
    ;;
esac

autoload -U compinit
compinit
zstyle ':completion::complete:*' use-cache 1

autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end

bindkey -e
bindkey "^W"    backward-delete-word
bindkey "\e[A"  history-beginning-search-backward-end
bindkey "\e[B"  history-beginning-search-forward-end
bindkey "\eOA"  history-beginning-search-backward-end
bindkey "\eOB"  history-beginning-search-forward-end

setopt correct
setopt list_packed
setopt noautoremoveslash
setopt nolistbeep
setopt hist_ignore_all_dups
setopt hist_save_nodups
unsetopt promptcr
setopt hist_ignore_dups
setopt share_history
setopt print_eightbit

HISTFILE=${HOME}/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

autoload zed

# show pwd on titlebar
function precmd(){
    echo -n "\e]2;${USER}@${hostname}:$(pwd)\a"
}

# ssh hostname completion
function print_known_hosts (){
  if [ -f $HOME/.ssh/known_hosts ]; then
    cat $HOME/.ssh/known_hosts | tr ',' ' ' | cut -d' ' -f1
  fi  
}
_cache_hosts=($( print_known_hosts ))


PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

source $HOME/.nvm/nvm.sh

