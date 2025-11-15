#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return


# Rust
export PATH="$HOME/.cargo/bin:$PATH"



# Android and Flutter

export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/platform-tools
export ANDROID_NDK_HOME="$ANDROID_HOME/ndk/29.0.14033849"


export PATH=$PATH:$HOME/SDK/flutter/bin


export PATH="$PATH":"$HOME/.pub-cache/bin"

export CHROME_EXECUTABLE=/usr/bin/google-chrome-stable



#######################################################
# Aliases
#######################################################


# n-m3u8dl-re-bin
alias m3u8dl="n-m3u8dl-re"

# Flutter
alias brb="dart run build_runner build --delete-conflicting-outputs"

# General shortcuts
alias c='clear'
alias q='exit'
alias ls='ls --color=auto'
alias ll='ls -la'
alias la='ls -A'
alias l='ls -CF'
alias grep='grep --color=auto'
alias mkdir='mkdir -p'

# Git aliases
alias dotfiles='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'

# Network shortcuts
alias wc='warp-cli connect'
alias wd='warp-cli disconnect'
alias myip='curl -s https://ipinfo.io/ip'

# Gaming/GPU
alias winegpu="__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia __VK_LAYER_NV_optimus=1"
alias winerun="$winegpu wine"

# AI and tools - converted to functions for lazy loading
alias audio_share="$HOME/Apps/audio-share-server-cmd/bin/as-cmd -b"

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '


# starship
eval "$(starship init bash)"
