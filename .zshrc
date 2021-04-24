#  basic configuration
#  ===================

export PATH="/usr/local/Caskroom/miniconda/base/bin:$PATH"
export LC_ALL=en_US.UTF-8

autoload -U colors && colors

# aliases
alias vim="nvim"
alias gs="git status"

# prompt
PROMPT="; "

# link ghcup
source ~/.ghcup/env

# vim bindings
# ============

# vi mode
bindkey -v

function zle-line-init zle-keymap-select {
    VIM_PROMPT="%{$fg_bold[yellow]%} [% NORMAL]% %{$reset_color%}"
    RPROMPT="${${KEYMAP/vicmd/$VIM_PROMPT}/(main|viins)/}"
    zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select
export KEYTIMEOUT=1
