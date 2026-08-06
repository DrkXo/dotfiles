### ---------------------------------------------------------
### 1. HISTORY & SHELL OPTIONS
### ---------------------------------------------------------
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=100000
export SAVEHIST=100000

# Zsh history options
setopt hist_ignore_dups      # Do not record duplicate commands
setopt hist_ignore_space     # Ignore commands starting with space
setopt share_history         # Share history instantly across sessions
setopt extended_history      # Save timestamps in history
setopt no_hist_beep          # Prevent beep on history boundary

# Directory navigation & usability options
# setopt auto_cd             # Disabled so all dir changes route through zoxide
setopt auto_pushd           # Make cd push old directory to stack
setopt pushd_ignore_dups    # Don't push duplicates to directory stack
setopt pushd_silent         # Hide directory stack output on cd
setopt rm_star_silent       # Don't prompt confirmation when running `rm path/*`
setopt interactive_comments # Allow comments (#) in interactive shell prompts


### ---------------------------------------------------------
### 2. ENVIRONMENT VARIABLES & PATHS
### ---------------------------------------------------------
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
export ANDROID_HOME="$HOME/Android/Sdk"
export ANDROID_NDK_HOME="$ANDROID_HOME/ndk/29.0.14033849"
export CHROME_EXECUTABLE="/usr/bin/google-chrome-stable"
export XDG_CURRENT_DESKTOP="KDE"
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border"

# Keep PATH clean and remove duplicates automatically
typeset -U path

path=(
  "$HOME/.local/bin"
  "$HOME/.cargo/bin"
  "$HOME/go/bin"
  "$HOME/fvm/bin"
  "$HOME/fvm/versions/3.44.2/bin"
  "$HOME/.pub-cache/bin"
  "$ANDROID_HOME/tools"
  "$ANDROID_HOME/platform-tools"
  "$ANDROID_HOME/emulator"
  "$ANDROID_HOME/cmdline-tools/latest/bin"
  "$HOME/miniforge3/bin"
  "$HOME/.local/lib/simutil"
  $path
)


### ---------------------------------------------------------
### 3. ZINIT PLUGIN MANAGER
### ---------------------------------------------------------
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

# Zinit Annexes
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust


### ---------------------------------------------------------
### 4. BINARIES MANAGED BY ZINIT
### ---------------------------------------------------------
# Install & manage eza directly from GitHub releases
zinit ice as"command" from"gh-r" pick"eza" \
  atload'
    alias ls="eza --icons=auto --hyperlink --color=auto"
    alias ll="eza -la --icons=auto --hyperlink --color=auto --git"
    alias la="eza -a --icons=auto --hyperlink --color=auto"
    alias l="eza -F --icons=auto"
  '
zinit light eza-community/eza

# Install & manage bat directly from GitHub releases
zinit ice as"command" from"gh-r" pick"bat/*/bat" \
  atload'alias cat="bat --style=plain"'
zinit light sharkdp/bat

# Install & manage Starship prompt with relative path generation
zinit ice as"command" from"gh-r" pick"starship" \
  atclone"./starship init zsh > init.zsh; zcompile init.zsh" \
  atpull"%atclone" src"init.zsh"
zinit light starship/starship


### ---------------------------------------------------------
### 5. PLUGINS & COMPLETION
### ---------------------------------------------------------
# Load completion definitions before running compinit
zinit light zsh-users/zsh-completions

# Optimized compinit call (uses cache if less than 24h old)
autoload -Uz compinit
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.m+1) ]]; then
  compinit
else
  compinit -C
fi

zmodload zsh/complist
zstyle ':completion:*' menu select

# History Substring Search
zinit ice wait"0a" lucid atload'
    bindkey "^[[A" history-substring-search-up
    bindkey "^[[B" history-substring-search-down
    bindkey "${terminfo[kcuu1]}" history-substring-search-up
    bindkey "${terminfo[kcud1]}" history-substring-search-down
'
zinit light zsh-users/zsh-history-substring-search

# Smart Directory Navigation (Zoxide overriding standard cd)
zinit ice as"command" from"gh-r" pick"zoxide" atload'eval "$(zoxide init zsh --cmd cd)"'
zinit light ajeetdsouza/zoxide

# Deferred interactive enhancement plugins (Turbo Mode)
zinit wait"0a" lucid light-mode for \
    Aloxaf/fzf-tab \
    zsh-users/zsh-autosuggestions \
    zdharma-continuum/fast-syntax-highlighting \
    MichaelAquilina/zsh-you-should-use \
    hlissner/zsh-autopair \
    wfxr/forgit

# Rich fzf-tab completion previews (Directory eza tree / File syntax preview)
zstyle ':fzf-tab:complete:*' fzf-preview \
    'if [[ -d $realpath ]]; then eza -1 --icons=auto --color=always $realpath; elif [[ -f $realpath ]]; then bat --color=always --style=header,grid $realpath 2>/dev/null || cat $realpath; fi'


### ---------------------------------------------------------
### 6. ALIASES & FUNCTIONS
### ---------------------------------------------------------
alias c="clear"
alias q="exit"
alias grep="grep --color=auto"
alias r="source ~/.zshrc"
alias mkdir="mkdir -p"

# Git
alias dotfiles='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias lg='lazygit'

# Network
alias wc='warp-cli connect'
alias wd='warp-cli disconnect'
alias myip='curl -s https://ipinfo.io/ip'

# GPU/Gaming
alias winegpu="__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia __VK_LAYER_NV_optimus=1 MANGOHUD=1"
alias winerun="$winegpu wine"

# Flutter
alias brb='dart run build_runner build --delete-conflicting-outputs'
alias fbrb='fvm dart run build_runner build --delete-conflicting-outputs'
alias fff='fvm flutter clean && fvm flutter pub get'

# Utilities
alias audio_share="$HOME/Apps/audio-share-server-cmd/bin/as-cmd -b"
alias m3u8dl='n-m3u8dl-re'
alias sm='python "$HOME/Apps/spatialmedia/gui.py"'
alias rsyncc='rsync -avhW --no-compress --progress'
alias batt60='echo 1 | sudo tee /sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode'
alias batt100='echo 0 | sudo tee /sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode'
alias lazypodman='DOCKER_HOST=unix:///run/user/1000/podman/podman.sock lazydocker'
alias zj='zellij attach --create "${USER}"'

# --- Functions ---
# Interactive sub-directory navigation with fzf
fd() {
  local dir
  dir=$(find ${1:-.} -path '*/.*' -prune -o -type d -print 2> /dev/null | fzf +m) && cd "$dir"
}

merge_ts() {
  local out="${1:-output.ts}"
  find . -type f -name "*.ts" -print0 \
    | sort -z -V \
    | xargs -0 cat > "$out"
  print "Created $out"
}

fbuild() {
  flutter build "$@"
  local rc=$?
  if [[ -d android ]]; then
    (cd android && ./gradlew --stop >/dev/null 2>&1)
  fi
  return $rc
}

# Lazy-load conda/mamba on first use
__mamba_init() {
  unset -f conda mamba
  if [[ -f "$HOME/miniforge3/etc/profile.d/conda.sh" ]]; then
    source "$HOME/miniforge3/etc/profile.d/conda.sh"
    eval "$("$HOME/miniforge3/bin/mamba" shell hook --shell zsh)"
  fi
}

conda() { __mamba_init; conda "$@"; }
mamba() { __mamba_init; mamba "$@"; }


### ---------------------------------------------------------
### 7. KEYBINDINGS
### ---------------------------------------------------------
# Default fallback arrow behavior (overridden by substring search once loaded)
bindkey "${terminfo[kcuu1]}" up-line-or-history
bindkey "${terminfo[kcud1]}" down-line-or-history
bindkey "${terminfo[kcub1]}" backward-char
bindkey "${terminfo[kcuf1]}" forward-char

# Menuselect keymap (completion menu)
bindkey -M menuselect '^[[Z' reverse-menu-complete
bindkey -M menuselect '^[[A' up-line-or-history
bindkey -M menuselect '^[[B' down-line-or-history
bindkey -M menuselect '^[[C' forward-char
bindkey -M menuselect '^[[D' backward-char

# Ctrl + Arrow keys word navigation
bindkey '^[[1;5D' backward-word
bindkey '^[[5D'   backward-word
bindkey '^[[1;5C' forward-word
bindkey '^[[5C'   forward-word
