#  basic configuration
#  ===================

export LC_ALL=en_US.UTF-8

autoload -U colors && colors

# aliases
alias vim="nvim"
alias gs="git status"
alias killtouchbar='sudo pkill TouchBarServer; sudo pkill ControlStrip'

alias newvenv="python3 -m venv .venv"
alias venv="source .venv/bin/activate"
alias reqs="pip install -r requirements.txt"

# prompt
PROMPT="; "

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

# misc
# ====

# Pomodoro session commands
alias work="timer -n 'Pomodoro: sessão de trabalho' 25m &&\
        terminal-notifier -title 'Pomodoro'\
        -message 'Sessão de trabalho acabou porraaaa!'\
        -sound Crystal"
        
alias rest="timer -n 'Pomodoro: sessão de descanso' 5m &&\
        terminal-notifier -title 'Pomodoro'\
        -message 'Dale dale dale puta que pariu!'\
        -sound Crystal"

