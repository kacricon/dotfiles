#  basic configuration
#  ===================

export LC_ALL=en_US.UTF-8
export PATH="$HOME/.bun/bin:$PATH"

# history
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS
setopt SHARE_HISTORY

autoload -U colors && colors

# completions
autoload -Uz compinit && compinit

# aliases
alias vim="nvim"
alias gs="git status"
alias newvenv="python3 -m venv .venv"
alias venv="source .venv/bin/activate"
alias reqs="pip install -r requirements.txt"
alias claude-yolo="claude --dangerously-skip-permissions"
alias codex-yolo="codex --dangerously-bypass-approvals-and-sandbox"

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

# zoxide (must come after compinit)
eval "$(zoxide init zsh)"
