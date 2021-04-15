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
    export PATH=$PATH:$HOME/.local/opt/julius/bin:$HOME/.gem/ruby/1.9.1/bin
    export SVKLOGLEVEL=
    ;;
esac

case `uname -rv` in
*gentoo*)
    prompt_bg=green
    prompt_fg=black
    ;;
*Ubuntu*)
    prompt_bg=yellow
    prompt_fg=black
    ;;
*Debian*)
    prompt_bg=magenta
    prompt_fg=white
    ;;
*FreeBSD*)
    prompt_bg=cyan
    prompt_fg=black
    ;;
*)
    prompt_bg=blue
    prompt_fg=white
    ;;
esac

git_ps1=""
if [ -f ~/.git-prompt.sh ]; then
    source ~/.git-prompt.sh
	GIT_PS1_SHOWDIRTYSTATE=true
	GIT_PS1_SHOWUNTRACKEDFILES=true
	GIT_PS1_SHOWSTASHSTATE=true
	GIT_PS1_SHOWUPSTREAM=auto
    setopt prompt_subst
    git_ps1='$(__git_ps1 " ${fg_bold[blue]}(%s)${reset_color}")'
fi

sep1=""
sep2=""

case ${UID} in
0)
    LANG=C
    RPROMPT=""
    PROMPT=$'\n'"${bg[red]}${fg[black]}${sep1}${bg[red]}${fg[white]} %n${fg[yellow]}@${fg[white]}${hostname} ${bg[white]}${fg[red]}${sep1} ${fg[black]}%~ ${bg[default]}${fg[white]}${sep1}${fg[default]}"$'\n'"%T${git_ps1} %B%#%b "
    ;;
*)
    RPROMPT=""
    PROMPT=$'\n'"${bg[$prompt_bg]}${fg[black]}${sep1}${bg[$prompt_bg]}${fg[$prompt_fg]} %n@${hostname} ${bg[white]}${fg[$prompt_bg]}${sep1} ${fg[black]}%~ ${bg[default]}${fg[white]}${sep1}${fg[default]}"$'\n'"%T${git_ps1} %B%#%b "
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

# set hostname to window-name of screen
function precmd(){
    if [[ $TERM == screen* ]]; then
        printf '\ek%s\e\\' ${hostname}
    fi
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
