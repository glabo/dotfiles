# .bashrc
alias l='ls'
alias la='ls -a'
alias c='clear'
alias reload='source ~/.bashrc'

# arista aliases
alias ch='a ws ch'
alias dl='a dut list'
alias dsa='a dut sanitize'
alias dup='a dut update'
alias dat='a dut attach'
alias din='a dut info'
alias dre='a dut release'
alias dgr='a dut grab'
alias actags='ctags -R --python-kinds=+cfmv --langmap=Python:+"(__init__)" --langmap=c++:+.tin --extra=+fq --fields=+im .'

# make vim the standard editor

export EDITOR=vim

# allow for vim colors
alias tmux="TERM=xterm-256color tmux"

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
