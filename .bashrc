#!/bin/bash
# ~/.bashrc

# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoredups

#### Prompt ####
RET_SMILEY='$(if [[ $? = 0 ]]; then echo -ne "\033[0;32m;)\033[0m"; else echo -ne "\033[0;31m;(\033[0m"; fi;)'
export PS1="[\w $RET_SMILEY]\$ "

#### Aliases ####

alias ll='ls -l'
alias ..='cd ..'

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize
