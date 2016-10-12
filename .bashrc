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
alias cpj='python ~/trees/ChangeProject.py'
alias ch='a ws ch'
alias dli='a dut list'
alias dsa='a dut sanitize'
alias dup='a dut update'
alias dat='a dut attach'
alias din='a dut info'
alias dre='a dut release'
alias dgr='a dut grab'
alias edit='a p4 edit'
alias actags='ctags -R --python-kinds=+cfmv --langmap=Python:+"(__init__)" --langmap=c++:+.tin --extra=+fq --fields=+im .'
alias searchtest='ls -R | grep '.py' | grep -ER '
alias kick='Abuildd -f $WP'
alias check='ap abuild -q -m 10 -p '

# make vim the standard editor
export EDITOR=vim
# custom PS1
#export PS1="[\[$(tput sgr0)\]\[\033[38;5;2m\]\$?\[$(tput sgr0)\]\[\033[38;5;15m\]]\[$(tput sgr0)\]\[\033[38;5;160m\]\A\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]\[\033[38;5;3m\]\w\[$(tput sgr0)\]\[\033[38;5;15m\] @\[$(tput sgr0)\]\[\033[38;5;3m\]\h\[$(tput sgr0)\]\[\033[38;5;15m\]\n\\$\[$(tput sgr0)\]"
#export PS1='\[\e[0;33m\]\u@\h: \w/\n[$?] [\t]\$ '

CYAN='\e[0;36m'
RED='\e[0;31m'
GRN='\e[0;32m'
END='\e[0m'

err() {
   if [ $? -ne 0 ]
   then
      echo -n "$RED\$?$END"
   else
      echo -n "$GRN\$?$END"
   fi
}

export PS1="$CYAN┌─$END[$(err)][@\h][$CYAN\w$END]
$CYAN└─▪$END "

export PS2="└─▪ "

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
