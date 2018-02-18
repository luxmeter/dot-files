export PYTHONSTARTUP=~/.pythonrc.py
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64
export M2_HOME=/usr/share/maven
export PATH=$PATH:/opt/maven3/bin

export EDITOR="vim"

if [ -d "$HOME/.local/bin" ]; then
    PATH="$HOME/.local/bin:$PATH"
fi
