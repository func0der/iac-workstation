#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

. ~/.bash_paths
eval "$(starship init bash)"

neofetch

alias dotfiles='/usr/bin/git --git-dir=$HOME/Projects/dotfiles --work-tree=$HOME'
