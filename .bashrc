#
# ~/.bashrc
# Source: https://github.com/termnml/dotfiles/blob/main/.bashrc

# test if shell is interactive
[[ $- != *i* ]] && return

# load system-specific default if present
# debian
if [ -f /etc/bash.bashrc ]; then
        . /etc/bash.bashrc
fi
# rhel
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

# test if completions is available 
[ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion

# Change the window title of X terminals
case ${TERM} in
	xterm*|rxvt*|Eterm*|aterm|kterm|gnome*|interix|konsole*)
		PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\007"'
		;;
	screen*)
		PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\033\\"'
		;;
esac

use_color=true

RESET='\[\e[0m\]'

RED='\[\e[00;31m\]'
GREEN='\[\e[00;32m\]'
YELLOW='\[\e[00;33m\]'
BLUE='\[\e[00;34m\]'
PURPLE='\[\e[00;35m\]'
CYAN='\[\e[00;36m\]'
LIGHTGRAY='\[\e[00;37m\]'

# Set colorful PS1 only on colorful terminals.
# dircolors --print-database uses its own built-in database
# instead of using /etc/DIR_COLORS.  Try to use the external file
# first to take advantage of user additions.  Use internal bash
# globbing instead of external grep binary.
safe_term=${TERM//[^[:alnum:]]/?}   # sanitize TERM
match_lhs=""
[[ -f ~/.dir_colors   ]] && match_lhs="${match_lhs}$(<~/.dir_colors)"
[[ -f /etc/DIR_COLORS ]] && match_lhs="${match_lhs}$(</etc/DIR_COLORS)"
[[ -z ${match_lhs}    ]] \
	&& type -P dircolors >/dev/null \
	&& match_lhs=$(dircolors --print-database)
[[ $'\n'${match_lhs} == *$'\n'"TERM "${safe_term}* ]] && use_color=true

if ${use_color} ; then
	# Enable colors for ls, etc.  Prefer ~/.dir_colors #64489
	if type -P dircolors >/dev/null ; then
		if [[ -f ~/.dir_colors ]] ; then
			eval $(dircolors -b ~/.dir_colors)
		elif [[ -f /etc/DIR_COLORS ]] ; then
			eval $(dircolors -b /etc/DIR_COLORS)
		fi
	fi
	
	if [[ ${EUID} == 0 ]] ; then
		# root
		PS1="${RED}[\u@\h][${BLUE}\w${RED}]${YELLOW}$(type __git_ps1 > /dev/null 2>&1 && __git_ps1)${RED}\n» ${RESET}\$ "
	else
		# non-root
		PS1="${GREEN}[\u@\h][${BLUE}\w${GREEN}]${YELLOW}$(type __git_ps1 > /dev/null 2>&1 && __git_ps1)${GREEN}\n» ${RESET}\$ "
	fi

	alias c='clear'
	alias ls='ls -l --color=auto'
	alias grep='grep --colour=auto'
	alias egrep='egrep --colour=auto'
	alias fgrep='fgrep --colour=auto'
else
	# no color escape-codes when not supported
	PS1='[\u@\h][\w]\n» \$ '
fi

unset use_color safe_term match_lhs sh

xhost +local:root > /dev/null 2>&1
complete -cf sudo

# Bash won't get SIGWINCH if another process is in the foreground.
# Enable checkwinsize so that bash will check the terminal size when
# it regains control.  #65623
# http://cnswww.cns.cwru.edu/~chet/bash/FAQ (E11)
shopt -s checkwinsize

shopt -s expand_aliases

# export QT_SELECT=4

# Enable history appending instead of overwriting.  #139609
shopt -s histappend

#
# # ex - archive extractor
# # usage: ex <file>
ex ()
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1     ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

###
# aliases
###
# ->  check if bins in path
# Source: https://stackoverflow.com/a/53798785/1331501
# Source: https://wiki.bash-hackers.org/howto/redirection_tutorial#a_note_on_style
# returns 0 when bin found
function bin_in_path {
  # redirect stdout and stderr to /dev/null
  builtin type -P "$1" > /dev/null 2>&1
  [[ $? -ne 0 ]] && return 1
  if [[ $# -gt 1 ]]; then
    shift  # We've just checked the first one
    bin_in_path "$@"
  fi
}

export TERM=xterm-256color

###
# ranger,lf marker
###
# - check if shell is running nested from ranger or lf
_ranger=$(echo $RANGER_LEVEL 2>/dev/null)
_lf=$(echo $LF_LEVEL 2>/dev/null)
# - prepend if ENV-Vars set
PS1=${_ranger:+"${BLUE}[R]"}${PS1}
PS1=${_lf:+"${BLUE}[LF]"}${PS1}

###
# lf - dir changer
###
# set path to last in flf when exiting
# source: https://sandeep.ramgolam.com/blog/lf
lfcd () {
    tmp="$(mktemp)"
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp"
        if [ -d "$dir" ]; then
            if [ "$dir" != "$(pwd)" ]; then
                cd "$dir"
            fi
        fi
    fi
}

################# core ################
alias cp="cp -i"                          # confirm before overwriting something
alias df='df -h'                          # human-readable sizes
alias free='free -h'
alias np='nano -w PKGBUILD'
alias more=less

# restart service for VM's
alias vwmtool_restart='systemctl restart vmtoolsd'
# fix pipesymbol when comming back from ranger
#alias ranger='ranger; echo -en "\e[?25h"'

# better C-d (don't clutter history)
alias q='exit'
# better C-l (don't clutter history)
alias c='clear'

bin_in_path tmux && \
alias t='tmux'

###
# less
###
export LESS=' -R -M '
# ->  less - highlight
#   - https://unix.stackexchange.com/a/139787/88645
bin_in_path src-hilite-lesspipe.sh && \
alias lessh='LESSOPEN="| src-hilite-lesspipe.sh %s" less -M -R '

###
# ls
###
# avoid backgroundcolor of ls
LS_COLORS=$LS_COLORS:'tw=00;33:ow=01;33:'; export LS_COLORS
# remap standard ls
alias ls='ls --color=auto'
alias ll='ls -l --color=auto'
alias la='ls -la --color=auto'

###
# grep
###
alias grep='grep --colour=auto'
alias egrep='egrep --colour=auto'
alias fgrep='fgrep --colour=auto'

###
# bash vi-mode
###
# start vi-mode with ESC
set -o vi
bind -m vi-command 'Control-l: clear-screen'
bind -m vi-insert 'Control-l: clear-screen'

# echo | on startup
# fixes missing pipesymbol (ranger)
#echo -en "\e[?25h"

###
# nvim
###
# for editor like lf, ranger
bin_in_path nvim && \
export EDITOR=nvim && \
export VISUAL=nvim

bin_in_path nvim && \
alias vim='nvim' && \
alias oldvim='\vim'

###
# colors
###
# -> https://askubuntu.com/a/677202
colors() {
  T='gYw'   # The test text
  echo -e "usage: echo -e \"\\\e[1;40mFoo_Bar\""
  echo -e "       \e[1;40mFoo_Bar\e[0m"
  echo -e "bg-color:       black    red    green   yellow   blue   purple   cyan    grey";
  echo -e "                 40m     41m     42m     43m     44m     45m     46m     47m";
  for FGs in '    m' '   1m' '  30m' '1;30m' '  31m' '1;31m' '  32m' \
    '1;32m' '  33m' '1;33m' '  34m' '1;34m' '  35m' '1;35m' \
    '  36m' '1;36m' '  37m' '1;37m';
  do
    FG=${FGs// /}
    echo -en " $FGs \033[$FG  $T  "
    for BG in 40m 41m 42m 43m 44m 45m 46m 47m;
    do
      echo -en "$EINS \033[$FG\033[$BG  $T  \033[0m";
    done
    echo;
  done
}
# alias for test
alias ccol='c && source ~/.bashrc && colors'

###
# fast dotfile-update (hardlinked to this repo)
###
update-dotfile-bashrc() {
  echo "'set -x' activate xtrace (bash command echo)"
  set -x
  rm ~/.bashrc
  wget -O ~/.bashrc https://raw.githubusercontent.com/termnml/dotfiles/main/.bashrc
  exec $SHELL
}

###
# local modifications
###
if [[ -f ~/.bashrc_local ]] ; then
	. ~/.bashrc_local
fi
