alias ls='ls --color'
alias ll='ls -lAh'
alias cp="cp --reflink=auto"
[ -z "$NVIM_LISTEN_ADDRESS" ] || alias :="${HOME}/.local/bin/nvimex.py"

#export TERM=xterm-256color
export EDITOR='nvim'
export HISTSIZE=1024
export SAVEHIST=2048
export HISTFILE=${HOME}/.cache/zsh/history
export PATH=$PATH:${HOME}/.local/bin
export PYTHONSTARTUP=${HOME}/.config/pystartup
export WORDCHARS='*?_-.[]~=&;!#$%^(){}<>' # doesn't include '/'
export NVIM_TUI_ENABLE_CURSOR_SHAPE=1
export NVIM_PYTHON_LOG_FILE=${HOME}/.cache/nvlogs/py
