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
alias s1='/home/lj/.screenlayout/2mon_dvi1.sh'
alias s2='/home/lj/.screenlayout/2mon_new.sh'
alias cbdtext='mupdf /home/lj/Documents/research/cbd-yt/cbd-in-a-nutshell-a-guidebook-to-the-cbd-process-dec-2016_low-res-protected.pdf'
alias phil='cd /home/lj/Documents/research/philosophy'
alias yt='cd /home/lj/Documents/research/cbd-yt'
alias bb='mupdf /home/lj/Documents/tabletop/bluebeard/MPG-BlubeardsBride-web-final.pdf'
alias bbb='vim /home/lj/Documents/translations/bluebeard/bluebeard-core.adoc'
alias cbdguide='mupdf /home/lj/Documents/research/cbd-yt/cbd-guide.pdf'
alias rando='feh -z --bg-fill /home/lj/Pictures/Wallpaper/gris -z --bg-fill /home/lj/Pictures/Wallpaper/gris/vertical'
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/.git --work-tree=$HOME'
