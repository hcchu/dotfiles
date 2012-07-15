fg_white=$'\e[1;37m'
fg_lcyan=$'\e[1;36m'
fg_gray=$'\e[0;37m'
fg_yellow=$'\e[1;33m'
fg_blue=$'\e[1;34m'
fg_green=$'\e[1;32m'
fg_none=$'\e[1;00m'

PROMPT="%{${fg_white}%}[%n@%M: %{${fg_green}%}%~%{${fg_white}%}]$ %{${fg_none}%}"

setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt AUTO_LIST AUTO_MENU

autoload -U compinit compinit
compinit

zstyle ':completion:*' list-colors ''
alias vi=vim
alias rdp="rdesktop -g 1024x768 -K -a 32 -f -u USA\hchu 10.29.5.123"
alias ls='ls --color'
