# Prompt
Red='\[\e[0;31m\]'
ColorReset='\[\e[0m\]'
li=$'\xe2\x98\xb2'

source /usr/local/etc/bash_completion.d/git-prompt.sh

export GIT_PS1_SHOWCOLORHINTS=1
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWUPSTREAM="auto"
PROMPT_COMMAND='__git_ps1 "$Red$li$ColorReset \W" ":> "'

# git Completion:
source /usr/local/etc/bash_completion.d/git-completion.bash

# Auto-load rbenv:
eval "$(rbenv init -)"

# Colors:
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced
export GREP_OPTIONS='--color=always'

# Set Sublime as the Default Editor:
which -s subl && export EDITOR="subl --wait"

# Useful Aliases:
alias vim="mvim -v"
alias e="subl"
alias be="bundle exec"
