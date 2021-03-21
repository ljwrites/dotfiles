#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '
alias xx='pkill x'
alias oo='startx'
alias sx='/home/lj/.screenlayout/2mon_10.sh'
alias rando='feh -z --bg-fill /home/lj/Pictures/Wallpaper/gris -z --bg-fill /home/lj/Pictures/Wallpaper/gris/vertical'
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/.git --work-tree=$HOME'
