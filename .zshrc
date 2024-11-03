
# Uncomment this and the last line at EOF to profile zsh startup
#zmodload zsh/zprof

# https://scriptingosx.com/2019/07/moving-to-zsh-06-customizing-the-zsh-prompt/
#export PROMPT='%~ %# '
# export PROMPT='%~ %# '
export PROMPT='%B%F{240}%~%f%b %# '
# export PROMPT='%(?.%F{green}√.%F{red}?%?)%f %B%F{240}%1~%f%b %# '
# export PROMPT='%(?.%F{green}√.%F{red}?%?)%f %B%F{240}%~%f%b %# '

export EDITOR="code -w"

# git info in RPROMPT
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
RPROMPT=\$vcs_info_msg_0_
# zstyle ':vcs_info:git:*' formats '%F{240}(%b)%r%f'
zstyle ':vcs_info:git:*' formats '%F{240}(%b)%f'
zstyle ':vcs_info:*' enable git

# History file https://scriptingosx.com/2019/06/moving-to-zsh-part-3-shell-options/
HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history
setopt EXTENDED_HISTORY
SAVEHIST=1000000000
HISTSIZE=1000000000
# share history across multiple zsh sessions
setopt SHARE_HISTORY
# append to history
setopt APPEND_HISTORY
# adds commands as they are typed, not at shell exit
setopt INC_APPEND_HISTORY
# expire duplicates first
setopt HIST_EXPIRE_DUPS_FIRST
# do not store duplications
setopt HIST_IGNORE_DUPS
#ignore duplicates when searching
setopt HIST_FIND_NO_DUPS
# removes blank lines from history
setopt HIST_REDUCE_BLANKS

# Typo corrections
# Always try to correct `git lg`, but should not
# setopt CORRECT
# setopt CORRECT_ALL

export PATH=$HOME/bin:$PATH
export PATH=/opt/homebrew/bin:$PATH

# https://scriptingosx.com/2019/07/moving-to-zsh-part-5-completions/
# https://docs.brew.sh/Shell-Completion
FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
autoload -Uz compinit && compinit
# case insensitive path-completion
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*'
# partial completion suggestions
# zstyle ':completion:*' list-suffixes
# zstyle ':completion:*' expand prefix suffix

# navigate completions using the arrow keys:
zstyle ':completion:*' menu select


# https://scriptingosx.com/2019/07/moving-to-zsh-part-7-miscellanea/
# History search using arrow keys
bindkey $'^[[A' up-line-or-search    # up arrow
bindkey $'^[[B' down-line-or-search  # down arrow

export LANG=en_US.UTF-8
export GIT_PAGER='less -FXR'

alias ll='ls -l'
alias ..='cd ..'

alias gti='git'
alias be='bundle exec'
alias ma='git checkout master'
alias bi='bundle install --jobs 4'
alias bu='bundle update --jobs 4'

# kubectl https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/kubectl/kubectl.plugin.zsh
alias keti='kubectl exec -ti'
alias kpf='kubectl port-forward'
alias kgp='kubectl get pods'

# Docker
alias docker-cleanup-containers='docker rm -f $(docker ps -a -q)'
alias docker-cleanup-images='docker rmi -f $(docker images -q)'

alias openreadme='open -a MacDown R[Ee][Aa][Dd][Mm]*'
alias curlstatus='curl -sL -w "%{http_code} %{url_effective}\\n" -o /dev/null'


# cd directly into these directories:
export cdpath=($HOME/data/repos/git $HOME/Library/Mobile\ Documents/com\~apple\~CloudDocs)
# ...append in zshrc_local like so:
# export cdpath=($cdpath $HOME/go/src/github.com/mat)

# Load .zshrc_local if present
[ -f $HOME/.zshrc_local ] && source $HOME/.zshrc_local

# EXPORT env variables contained within a .env file
dotenv () {
  set -a
  [ -f .env ] && source .env
  set +a
}

pdfrenamer-local () {
    java -jar $HOME/jars/pdfrenamer.jar $@
}

# Fix kubectl bash completion...
source <(kubectl completion zsh)

eval "$(/opt/homebrew/bin/brew shellenv)"

#zprof