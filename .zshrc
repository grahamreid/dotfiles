# Path to your oh-my-zsh installation.
export ZSH="/Users/grahamreid/.oh-my-zsh"

ZSH_THEME="refined"

bindkey "ƒ" forward-word
bindkey "∫" backward-word

# https_proxy=$http_proxy
# echo "export http_proxy=$http_proxy" > $HOME/.proxyrc
# echo "export HTTP_PROXY=$http_proxy" >> $HOME/.proxyrc
# echo "export https_proxy=$https_proxy" >> $HOME/.proxyrc
# echo "export HTTPS_PROXY=$https_proxy" >> $HOME/.proxyrc
# . $HOME/.proxyrc

zssh() ssh "$@" -t zsh

plugins=(
  git,
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# User configuration

alias ohmyzsh="mate ~/.oh-my-zsh"
