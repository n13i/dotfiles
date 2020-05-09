# m2hq.net Common ~/.zshrc

#zmodload zsh/zprof && zprof

export LANG=ja_JP.UTF-8

alias less=lv

autoload colors
colors

editor_cmds=(nvim vim vi nano)
editor_paths=(/usr/bin /usr/local/bin)
for cmd in $editor_cmds; do
    for p in $editor_paths; do
        if [ -e $p/$cmd ]; then
            export EDITOR=$p/$cmd
            alias vi=$cmd
            break 2
        fi
    done
done

export PAGER=less

case "${OSTYPE}" in
freebsd*)
    alias ls="ls -G -w"
    #alias vi=vim
    #export EDITOR=/usr/local/bin/vim
    #export PAGER=/usr/local/bin/lv
    hostname=`hostname -s`
    ;;
linux-android)
    alias ls="ls --color"
    #alias vi=nvim
    #export EDITOR=/usr/bin/nvim
    #export PAGER=/usr/bin/lv
    export PAGER=less
    hostname=`hostname -s`
    ;;
linux*)
    alias ls="ls --color"
    #export EDITOR=/usr/bin/vim
    #export PAGER=/usr/bin/lv
    export PAGER=less
    hostname=`hostname -s`
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
beast.local.m2hq.net)
    unalias less
    alias vi=nvim
    #export EDITOR=/usr/local/bin/nvim
    ;;
*)
    unalias less
    export PATH=$PATH:$HOME/.local/bin
    promptcolor=white
    promptcolor2=white
    ;;
esac


sep1=""
sep2=""

case ${UID} in
0)
    LANG=C
    RPROMPT="%T"
    PROMPT=$'\n'"${bg[red]}${fg[black]}${sep1}${bg[red]}${fg[white]} %n${fg[yellow]}@${fg[white]}${hostname} ${bg[white]}${fg[red]}${sep1} ${fg[black]}%~ ${bg[default]}${fg[white]}${sep1}"$'\n'"${fg[default]}%B%%b "
    ;;
*)
    RPROMPT="%T"
    PROMPT=$'\n'"${bg[blue]}${fg[black]}${sep1}${bg[blue]}${fg[white]} %n${fg[cyan]}@${fg[white]}${hostname} ${bg[white]}${fg[blue]}${sep1} ${fg[black]}%~ ${bg[default]}${fg[white]}${sep1}"$'\n'"${fg[default]}%B%#%b "
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

# https://qiita.com/uasi/items/80865646607b966aedc8
function nvm(){
    unset -f nvm
    source $HOME/.nvm/nvm.sh
    nvm "$@"
}

#if (which zprof > /dev/null 2>&1); then
#    zprof
#fi
