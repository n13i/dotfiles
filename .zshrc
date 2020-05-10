# m2hq.net Common ~/.zshrc

#zmodload zsh/zprof && zprof

export LANG=ja_JP.UTF-8
export GOPATH=$HOME/.go
export PATH=$PATH:$HOME/.local/bin:$HOME/.rvm/bin:$GOPATH/bin
export PAGER=less

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

case "${OSTYPE}" in
freebsd*)
    alias ls="ls -G -w"
    hostname=`hostname -s`
    ;;
linux-android)
    alias ls="ls --color"
    hostname=`hostname -s`
    ;;
linux*)
    alias ls="ls --color"
    hostname=`hostname -s`
    ;;
esac

# per host settings
case `hostname -s` in
scarface)
    promptcolor=green
    export PATH=$PATH:$HOME/.local/opt/julius/bin:$HOME/.gem/ruby/1.9.1/bin
    export SVKLOGLEVEL=
    ;;
ouroboros)
    promptcolor=yellow
    ;;
*)
    promptcolor=cyan
    ;;
esac


sep1=""
sep2=""

case ${UID} in
0)
    LANG=C
    RPROMPT="%T"
    PROMPT=$'\n'"${bg[red]}${fg[black]}${sep1}${bg[red]}${fg[white]} %n${fg[yellow]}@${fg[white]}${hostname} ${bg[white]}${fg[red]}${sep1} ${fg[black]}%~ ${bg[default]}${fg[white]}${sep1}"$'\n'"${fg[default]}%B%#%b "
    ;;
*)
    RPROMPT="%T"
    PROMPT=$'\n'"${bg[$promptcolor]}${fg[black]}${sep1}${bg[$promptcolor]}${fg[black]} %n@${hostname} ${bg[white]}${fg[$promptcolor]}${sep1} ${fg[black]}%~ ${bg[default]}${fg[white]}${sep1}"$'\n'"${fg[default]}%B%#%b "
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

# https://qiita.com/uasi/items/80865646607b966aedc8
function nvm(){
    unset -f nvm
    source $HOME/.nvm/nvm.sh
    nvm "$@"
}

#if (which zprof > /dev/null 2>&1); then
#    zprof
#fi
