# ~/.bashrc: executed by bash(1) for non-login shells.

# If not running interactively, don't do anything
case $- in
*i*) ;;
*) return ;;
esac

# Don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth

# Append to the history file, don't overwrite it
shopt -s histappend

# History length
HISTSIZE=1000
HISTFILESIZE=2000

# Check window size after each command
shopt -s checkwinsize

# Set colored prompt
export VIRTUAL_ENV_DISABLE_PROMPT=1
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
  if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    color_prompt=yes
  else
    color_prompt=
  fi
fi

if [ "$color_prompt" = yes ]; then
  case "$TERM" in
  xterm* | rxvt*)
    export PS1="\[\e[1;32m\]\${VIRTUAL_ENV:+(\${VIRTUAL_ENV##*/}) }\[\e[1;33m\]\w\[\e[0m\]\n\[\e[1;36m\]❯\[\e[0m\] "
    ;;
  *)
    export PS1="\[\e[1;32m\]\${VIRTUAL_ENV:+(\${VIRTUAL_ENV##*/}) }\[\e[1;33m\]\w\[\e[0m\]\n\[\e[1;36m\]❯\[\e[0m\] "
    ;;
  esac
else
  PS1='\u@\h:\w\$ '
fi

unset color_prompt force_color_prompt

# Enable color support of ls and dircolors
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'
  alias grep='grep --color=auto'
fi

# Colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Aliases
export EZA_COLORS="da=38;5;244"
alias l='eza -l --icons=always --color=always --git'
alias la='ls -A'
alias ll='ls -l'
alias lc='ls -CF'
alias lt='tree -L 2'

alias zed='flatpak run dev.zed.Zed'
alias gst='git status'
alias vi='nvim'
alias vim='nvim'
alias fetch='fetch --shading-mode sextants'
alias waybar-reload='pkill -x waybar; waybar > ~/.config/waybar/waybar.log 2>&1 & disown'
alias xinstall='xbps-install'
alias xsrc='xbps-src'

# Pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv >/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

# Load custom aliases if present
if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

# Programmable completion
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Direnv
if command -v direnv >/dev/null 2>&1; then
  eval "$(direnv hook bash)"
fi

# User local bin and Cargo
export PATH="$HOME/.local/bin:$PATH"
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
