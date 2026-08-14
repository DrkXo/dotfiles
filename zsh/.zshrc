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
setopt inc_append_history    # Immediately write to history file
setopt extended_history      # Save timestamps in history
setopt hist_expire_dups_first # Expire duplicates first when trimming history
setopt hist_find_no_dups     # Do not display duplicates when searching
setopt no_hist_beep          # Prevent beep on history boundary

# Directory navigation & usability options
setopt auto_pushd            # Make cd push old directory to stack
setopt pushd_ignore_dups     # Don't push duplicates to directory stack
setopt pushd_silent          # Hide directory stack output on cd
setopt interactive_comments  # Allow comments (#) in interactive shell prompts


### ---------------------------------------------------------
### 2. ENVIRONMENT VARIABLES & PATHS
### ---------------------------------------------------------
export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR:-/run/user/$UID}/ssh-agent.socket"
export ANDROID_HOME="$HOME/Android/Sdk"
export ANDROID_NDK_HOME="$ANDROID_HOME/ndk/29.0.14033849"
export CHROME_EXECUTABLE="/usr/bin/google-chrome-stable"
export XDG_CURRENT_DESKTOP="KDE"
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border"

# Deduplicate scalar PATH and array path cleanly
typeset -U path PATH fpath FPATH

path=(
  "$HOME/.local/bin"
  "$HOME/.local/lib/simutil"
  "$HOME/.cargo/bin"
  "$HOME/go/bin"
  "$HOME/fvm/default/bin"
  "$HOME/fvm/bin"
  "$HOME/.pub-cache/bin"
  "$ANDROID_HOME/cmdline-tools/latest/bin"
  "$ANDROID_HOME/platform-tools"
  "$ANDROID_HOME/emulator"
  "$ANDROID_HOME/tools"
  $path
)
export PATH


### ---------------------------------------------------------
### 3. ZINIT PLUGIN MANAGER
### ---------------------------------------------------------
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [[ ! -d "$ZINIT_HOME" ]]; then
    print -P "%F{33}Installing ZDHARMA-CONTINUUM Zinit…%f"
    mkdir -p "$(dirname "$ZINIT_HOME")"
    git clone https://github.com/zdharma-continuum/zinit "$ZINIT_HOME"
fi

source "$ZINIT_HOME/zinit.zsh"

zinit light zdharma-continuum/zinit-annex-bin-gem-node


### ---------------------------------------------------------
### 4. BINARIES MANAGED BY ZINIT
### ---------------------------------------------------------
# eza
zinit ice as"command" from"gh-r" pick"eza"
zinit light eza-community/eza

# bat
zinit ice as"command" from"gh-r" bpick"*.tar.gz" mv"bat-* -> bat" pick"bat/bat"
zinit light sharkdp/bat

# fzf
zinit ice as"command" from"gh-r" bpick"*.tar.gz" pick"fzf" \
    atclone'./fzf --zsh > fzf.zsh 2>/dev/null || true' \
    atpull'%atclone' \
    src"fzf.zsh"
zinit light junegunn/fzf

# delta
zinit ice as"command" from"gh-r" bpick"*.tar.gz" pick"delta*/delta" \
    atload'export GIT_PAGER="delta"'
zinit light dandavison/delta

# Oh My Posh Binary
zinit ice as"command" from"gh-r" bpick"*linux-amd64" mv"posh* -> oh-my-posh" pick"oh-my-posh"
zinit light JanDeDobbeleer/oh-my-posh

# Oh My Posh Theme Setup & Initialization
mkdir -p "$HOME/.config/ohmyposh"
if [[ ! -f "$HOME/.config/ohmyposh/default.omp.json" ]]; then
    curl -fsSL https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/uew.omp.json -o "$HOME/.config/ohmyposh/default.omp.json"
fi

if command -v oh-my-posh &>/dev/null; then
    eval "$(oh-my-posh init zsh --config "$HOME/.config/ohmyposh/default.omp.json")"
fi

### ---------------------------------------------------------
### 5. PLUGINS & COMPLETION
### ---------------------------------------------------------
zinit light zsh-users/zsh-completions

# Fixed & Optimized Completion initialization
autoload -Uz compinit
ZCOMPDUMP="${ZDOTDIR:-$HOME}/.zcompdump"
if [[ -n ${ZCOMPDUMP}(N.mh+24) ]]; then
  compinit -d "$ZCOMPDUMP"
  touch "$ZCOMPDUMP"
else
  compinit -C -d "$ZCOMPDUMP"
fi

zmodload zsh/complist
zstyle ':completion:*' menu select

zinit light zsh-users/zsh-autosuggestions

# fzf-tab
zinit ice compile"lib/*"
zinit light Aloxaf/fzf-tab

zstyle ':fzf-tab:complete:*' fzf-preview \
    'if [[ -d $realpath ]]; then eza -1 --icons=auto --color=always $realpath; elif [[ -f $realpath ]]; then bat --color=always --style=header,grid $realpath 2>/dev/null || cat $realpath; fi'

# Zoxide
zinit ice as"command" from"gh-r" pick"zoxide" atload'eval "$(zoxide init zsh --cmd cd)"'
zinit light ajeetdsouza/zoxide

# Deferred Plugins (Background loading)
zinit wait"0" lucid light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust \
    zdharma-continuum/fast-syntax-highlighting \
    MichaelAquilina/zsh-you-should-use \
    hlissner/zsh-autopair \
    wfxr/forgit

# Deferred Substring Search
zinit ice wait"0" lucid atload'
    bindkey "^[[A" history-substring-search-up
    bindkey "^[[B" history-substring-search-down
    bindkey "${terminfo[kcuu1]}" history-substring-search-up
    bindkey "${terminfo[kcud1]}" history-substring-search-down
'
zinit light zsh-users/zsh-history-substring-search


### ---------------------------------------------------------
### 6. ALIASES & FUNCTIONS
### ---------------------------------------------------------
alias c="clear"
alias q="exit"
alias grep="grep --color=auto"
alias r="source ~/.zshrc"
alias mkdir="mkdir -p"

# eza / bat aliases
if command -v eza &>/dev/null; then
  alias ls="eza --icons=auto --hyperlink --color=auto"
  alias ll="eza -la --icons=auto --hyperlink --color=auto --git"
  alias la="eza -a --icons=auto --hyperlink --color=auto"
  alias l="eza -F --icons=auto"
fi

if command -v bat &>/dev/null; then
  alias cat="bat --style=plain"
fi

if command -v trash-put &>/dev/null; then
  alias rm="trash-put"
fi

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
alias lp='lazypodman'
alias zj='zellij attach --create "${USER}"'
alias copydir="pwd | qdbus org.kde.klipper /klipper setClipboardContents 2>/dev/null || pwd | wl-copy 2>/dev/null || pwd | xclip -selection clipboard 2>/dev/null"
alias poshreload="zi delete JanDeDobbeleer/oh-my-posh -y && exec zsh"

# SSH
alias sshkey='eval "$(ssh-agent -s)" && ssh-add ~/.ssh/id_ed25519'

# --- Functions ---
fd() {
  local dir
  if command -v fd &>/dev/null; then
    dir=$(command fd --type d --hidden --exclude .git | fzf +m) && cd "$dir"
  else
    dir=$(find "${1:-.}" -maxdepth 4 \( -path '*/.*' -o -path '*/node_modules' \) -prune -o -type d -print 2>/dev/null | fzf +m) && cd "$dir"
  fi
}

extract() {
  if [[ -f "$1" ]]; then
    case "$1" in
      *.tar.bz2|*.tbz2) if command -v pv &>/dev/null; then pv "$1" | tar xjf -; else tar xvjf "$1"; fi ;;
      *.tar.gz|*.tgz)   if command -v pv &>/dev/null; then pv "$1" | tar xzf -; else tar xvzf "$1"; fi ;;
      *.tar)            if command -v pv &>/dev/null; then pv "$1" | tar xf -; else tar xvf "$1"; fi ;;
      *.bz2)            if command -v pv &>/dev/null; then pv "$1" | bunzip2 > "${1%.bz2}"; else bunzip2 -v "$1"; fi ;;
      *.gz)             if command -v pv &>/dev/null; then pv "$1" | gunzip > "${1%.gz}"; else gunzip -v "$1"; fi ;;
      *.rar)            unrar x "$1" ;;
      *.zip)            unzip "$1" ;;
      *.Z)              compress -d "$1" ;;
      *.7z)             7z x "$1" ;;
      *)                echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

merge_ts() {
  local out="${1:-output.ts}"
  find . -type f -name "*.ts" -print0 | sort -z -V | xargs -0 cat > "$out"
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
bindkey "${terminfo[kcub1]}" backward-char
bindkey "${terminfo[kcuf1]}" forward-char

bindkey -M menuselect '^[[Z' reverse-menu-complete
bindkey -M menuselect '^[[A' up-line-or-history
bindkey -M menuselect '^[[B' down-line-or-history
bindkey -M menuselect '^[[C' forward-char
bindkey -M menuselect '^[[D' backward-char

bindkey '^[[1;5D' backward-word
bindkey '^[[5D'   backward-word
bindkey '^[[1;5C' forward-word
bindkey '^[[5C'   forward-word
