# .bashrc
alias l='ls'
alias la='ls -a'
alias c='clear'
alias reload='source ~/.bashrc'
alias bashrc='vim ~/.bashrc'

# git alias for pushing dotfiles
alias pushdotfiles='tempDir=$PWD && \
                     cd ~/.vim && \
                     git add . && \
                     git commit && \
                     git push origin master && \
                     cd $tempDir && \
                     unset tempDir'

# arista aliases
alias ch='a ws ch'
alias dli='a dut list'
alias dsa='a dut sanitize'
alias dup='a dut update'
alias dat='a dut attach'
alias din='a dut info'
alias dre='a dut release'
alias dgr='a dut grab'
alias actags='ctags -R --python-kinds=+cfmv --langmap=Python:+"(__init__)" --langmap=c++:+.tin --extra=+fq --fields=+im .'
alias searchtest='ls -R | grep '.py' | grep -ER '

# make vim the standard editor
export EDITOR=vim

# allow for vim colors
alias tmux="TERM=xterm-256color tmux"
alias tmat='tmux attach'

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
