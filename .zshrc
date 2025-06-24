# Enable profiling - uncomment these lines when debugging performance
# zmodload zsh/zprof

#######################################################
# zinit initial
#######################################################

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zinit's installer chunk

#######################################################
# zsh plugins
#######################################################

# Load starship theme immediately (not in turbo mode)
# This ensures your prompt is available on initial launch
zinit ice as"command" from"gh-r" \
          atclone"./starship init zsh > init.zsh; ./starship completions zsh > _starship" \
          atpull"%atclone" src"init.zsh"
zinit light starship/starship

# Essential ZSH plugins with turbo mode for async loading
zinit ice wait lucid
zinit light zsh-users/zsh-syntax-highlighting

zinit ice wait lucid
zinit light zsh-users/zsh-completions

zinit ice wait lucid atload'_zsh_autosuggest_start'
zinit light zsh-users/zsh-autosuggestions

zinit ice wait lucid
zinit light Aloxaf/fzf-tab

# Additional plugins also with turbo mode - history-substring-search with proper key binding setup
zinit ice wait lucid atload'bindkey "^[[A" history-substring-search-up; bindkey "^[[B" history-substring-search-down'
zinit light zsh-users/zsh-history-substring-search

zinit ice wait lucid
zinit light zdharma-continuum/fast-syntax-highlighting

# Completions - moved to the end and optimized
# This speeds up shell startup by deferring completion initialization
# First load the cache if it exists
if [[ -f "$HOME/.zcompdump" ]]; then
  autoload -Uz compinit
  compinit -C
else
  autoload -Uz compinit
  compinit
fi

# Apply zinit's completion after everything else
zinit cdreplay -q

#######################################################
# ZSH Basic Options
#######################################################

# Better keybindings - these are standard ZSH keybindings that don't depend on plugins
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

setopt autocd              # change directory just by typing its name
setopt correct             # auto correct mistakes
setopt interactivecomments # allow comments in interactive mode
setopt magicequalsubst     # enable filename expansion for arguments of the form 'anything=expression'
setopt nonomatch           # hide error message if there is no match for the pattern
setopt notify              # report the status of background jobs immediately
setopt numericglobsort     # sort filenames numerically when it makes sense
setopt promptsubst         # enable command substitution in prompt

# Additional useful options
setopt auto_pushd          # make cd push the old directory onto the directory stack
setopt pushd_ignore_dups   # don't push multiple copies of the same directory onto the directory stack
setopt extended_glob       # treat #, ~, and ^ as part of patterns for filename generation

#######################################################
# conda setup - lazy loading to improve startup time
#######################################################

# Lazy load conda - only initialize when actually needed
conda() {
  unfunction conda
  CONDA_PATH="$HOME/SDK/miniconda3"
  if [[ -d "$CONDA_PATH" ]]; then
    # Add conda to PATH so the function works
    export PATH="$CONDA_PATH/bin:$PATH"

    __conda_setup="$('$CONDA_PATH/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
    if [ $? -eq 0 ]; then
      eval "$__conda_setup"
    else
      if [ -f "$CONDA_PATH/etc/profile.d/conda.sh" ]; then
        . "$CONDA_PATH/etc/profile.d/conda.sh"
      fi
    fi
    unset __conda_setup
  fi
  conda "$@"
}

# Create wrapper for conda activate to support lazy loading
conda-activate() {
  conda activate "$@"
}

#######################################################
# History Configuration
#######################################################

HISTSIZE=100000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups
setopt hist_reduce_blanks       # Remove superfluous blanks from history items
setopt inc_append_history       # Save history entries as soon as they are entered
setopt extended_history         # Record timestamp of command in HISTFILE

#######################################################
# Aliases
#######################################################

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

# Improved zypper speed
# alias zypper="ZYPP_PCK_PRELOAD=1 ZYPP_CURL2=1 zypper"

#######################################################
# Functions
#######################################################

# Download with Aria2
function aria2cp() {
    aria2c -x 16 -s 16 -k 1M "${1}"
}

# Improved copy with progress
function cpp() {
    if [[ -x "$(command -v rsync)" ]]; then
        rsync -ah --info=progress2 "${1}" "${2}"
    else
        set -e
        strace -q -ewrite cp -- "${1}" "${2}" 2>&1 \
        | awk '{
        count += $NF
        if (count % 10 == 0) {
            percent = count / total_size * 100
            printf "%3d%% [", percent
            for (i=0;i<=percent;i++)
                printf "="
                printf ">"
                for (i=percent;i<100;i++)
                    printf " "
                    printf "]\r"
                }
            }
        END { print "" }' total_size=$(stat -c '%s' "${1}") count=0
    fi
}

# FaceFusion function (lazy loaded instead of alias)
function facefusion() {
    conda activate facefusion && cd $HOME/SDK/Ai/facefusion && python facefusion.py run --open-browser
}

# Extract common archive formats
extract() {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xjf $1     ;;
            *.tar.gz)    tar xzf $1     ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar e $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xf $1      ;;
            *.tbz2)      tar xjf $1     ;;
            *.tgz)       tar xzf $1     ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)           echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Make directory and change into it
mkcd() {
    mkdir -p "$1" && cd "$1"
}

#######################################################
# Environment Variables
#######################################################

# Android and Flutter - lazy loaded
android_env() {
    export CHROME_EXECUTABLE=/usr/bin/google-chrome-stable

    export ANDROID_HOME="$HOME/Android/Sdk"
    export PATH="$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools"
    export PATH="$PATH:$HOME/SDK/flutter/bin"
    export PATH="$PATH:$HOME/.pub-cache/bin"
}

# Only load Android environment when needed
for cmd in flutter dart adb; do
    alias $cmd="android_env && $cmd"
done

# Add local bins to PATH
if [ -d "$HOME/.local/bin" ]; then
    export PATH="$HOME/.local/bin:$PATH"
fi

# Editor config
export EDITOR="vim"
export VISUAL="vim"

# FZF settings - lazy loaded only if used
_fzf_load() {
    unfunction fzf
    if [ -f ~/.fzf.zsh ]; then
        source ~/.fzf.zsh
    fi
    fzf "$@"
}
alias fzf=_fzf_load

# Load local customizations if present, but defer until after shell startup
if [ -f ~/.zshrc.local ]; then
    # Use a small timer to load it after shell is ready
    (( ${+commands[zsh-defer]} )) || {
        zinit light romkatv/zsh-defer
    }
    zsh-defer source ~/.zshrc.local
fi

# Enable this line when you need to debug startup performance
# zprof
