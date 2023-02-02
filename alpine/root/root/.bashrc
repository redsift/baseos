# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Disable systemctl's auto-paging feature:
export SYSTEMD_PAGER=

# User specific aliases and functions
export TERM="xterm-256color"
export PS1="\[$(tput setaf 6)\]\t \[$(tput setaf 1)\]\u\[$(tput setaf 3)\]@\[$(tput setaf 1)\]\h:\l \[$(tput setaf 6)\]\w\[$(tput setaf 4)\] \\$ \[$(tput sgr0)\]"

shopt -s nullglob
if [ -d ~/.bashrc.d ]; then
	for rc in ~/.bashrc.d/*
	do
		. $rc
	done
fi
shopt -u nullglob