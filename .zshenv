#export TERM=xterm-256color
export PYTHONSTARTUP=~/.pythonrc.py
export JAVA_HOME=/opt/jdk1.8.0_45/
export M2_HOME=/opt/maven3
export PATH=$PATH:/opt/maven3/bin

if [ -d "$HOME/.local/bin" ]; then
    PATH="$HOME/.local/bin:$PATH"
fi

if [[ -z $TMUX ]]; then
    if [ -e /usr/share/terminfo/x/xterm+256color ]; then # may be xterm-256 depending on your distro
        export TERM='xterm-256color'
    else
        export TERM='xterm'
    fi
else
    if [ -e /usr/share/terminfo/s/screen-256color ]; then
        export TERM='screen-256color'
    else
        export TERM='screen'
    fi
fi
