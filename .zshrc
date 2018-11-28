# Path to your oh-my-zsh installation.
export ZSH="/Users/grahamreid/.oh-my-zsh"

ZSH_THEME="refined"

bindkey "ƒ" forward-word
bindkey "∫" backward-word

# http_proxy=""
# https_proxy=$http_proxy
# echo "export http_proxy=$http_proxy" > $HOME/.proxyrc
# echo "export HTTP_PROXY=$http_proxy" >> $HOME/.proxyrc
# echo "export https_proxy=$https_proxy" >> $HOME/.proxyrc
# echo "export HTTPS_PROXY=$https_proxy" >> $HOME/.proxyrc
# echo "export no_proxy=\".ge.com\"" >> $HOME/.proxyrc
# echo "export NO_PROXY=\".ge.com\"" >> $HOME/.proxyrc
# . $HOME/.proxyrc

SPARK_HOME=/Users/grahamreid/spark
PATH=$SPARK_HOME/bin:$PATH
export SPARK_HOME=/Users/grahamreid/spark
export PYSPARK_DRIVER_PYTHON=jupyter
export PYSPARK_DRIVER_PYTHON_OPTS='notebook'
export PYSPARK_PYTHON=python3

zssh() ssh "$@" -t zsh

plugins=(
  git,
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# User configuration

alias ohmyzsh="mate ~/.oh-my-zsh"
