
# When a "login shell" starts up, it reads the file "/etc/profile" 
# and then "~/.bash_profile" or "~/.bash_login" or "~/.profile" 
# (whichever one exists - it only reads one of these) 

if [ -f ~/.aliases ]; then
  . ~/.aliases
fi

if [ -f ~/.functions ]; then
  . ~/.functions
fi

if [ -d ~/profile.d ]; then
  for f in ~/profile.d/*; do
    source $f
  done
fi

if [ -f ~/.bashrc ]; then
   source ~/.bashrc
fi

export PATH=/usr/local/sbin:/usr/local/bin:${PATH}
export PATH=$HOME/bin:$PATH

export EDITOR="mate -w"

export HISTCONTROL=ignoredups
export HISTSIZE=100000
export HISTFILE="$HOME/.bash_history"
export SAVEHIST=$HISTSIZE
