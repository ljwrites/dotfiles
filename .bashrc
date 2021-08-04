#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '
# alias xx='pkill x'
xx () {
    emacsclient -e '(desktop-save "~/.emacs.d/desktop")'
    pkill x
}
alias oo='startx'
alias s1='/home/lj/.screenlayout/1mon-1.sh'
alias s11='/home/lj/.screenlayout/1mon-1.sh'
alias s12='/home/lj/.screenlayout/1mon-2.sh'
alias s2='/home/lj/.screenlayout/2mon_dvi1.sh'
alias s21='/home/lj/.screenlayout/2mon_dvi1.sh'
alias s22='/home/lj/.screenlayout/2mon_dvi2.sh'
alias rando='feh -z --bg-fill /home/lj/Pictures/Wallpaper/gris -z --bg-fill /home/lj/Pictures/Wallpaper/gris/vertical'
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/.git --work-tree=$HOME'

findstring() {
    #search current directory for a file containing the string
    find ./ -type f -exec grep -l "$1" {} \; 
}

#added .local/bin and go/bin to $PATH
PATH=$HOME/.local/bin:$HOME/go/bin:$PATH

alias backupcheck='sudo journalctl -u filebackup.*'

# export SSH_AUTH_SOCK
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
