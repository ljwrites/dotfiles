#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap
setxkbmap -device 13 -layout us -variant dvorak 
setxkbmap -device 10 -layout us -variant dvorak 
setxkbmap -layout us -variant dvorak # -option ctrl:swapcaps

# merge in defaults and keymaps

export GTK_IM_MODULE='uim'
export QT_IM_MODULE='uim' 
uim-xim &
uim-toolbar-gtk3 &
# uim-toolbar-qt5 &
export XMODIFIERS='@im=uim'

if [ -f $sysresources ]; then

    xrdb -merge $sysresources

fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then


    xrdb -merge "$userresources"

fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

xbindkeys

# stopped ssh-agent.service, setting environment here
#DISPLAY=:0
# set ssh-askpass (symlinked to x11-ssh-askpass) as the SSH_ASKPASS variable
#export SSH_ASKPASS=ssh-askpass
SSH_ASKPASS=ssh-askpass
 start ssh-agent
eval $(ssh-agent)

# uncomment below for dual monitor setup
#~/.screenlayout/2mon_dvi1.sh & 
# uncomment below for single monitor setup
~/.screenlayout/1mon-1.sh & 
exec i3
