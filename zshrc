# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

if command -v vim &>/dev/null; then
  export EDITOR=vim
  export VISUAL=vim
elif command -v vi &>/dev/null; then
  export EDITOR=vi
  export VISUAL=vi
fi

if [ "${TERM:-}" = 'alacritty' ]; then
  export COLORTERM=truecolor
fi

# Path to your oh-my-zsh installation.
export ZSH=${XDG_CONFIG_HOME:-${HOME:-~}/.config}/dotfiles/oh-my-zsh
export ZSH_CUSTOM=${XDG_CONFIG_HOME:-${HOME:-~}/.config}/dotfiles/omz-custom

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="yyyy-mm-dd"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(zsh-autosuggestions)

# https://github.com/zsh-users/zsh-completions/issues/603
fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src

source $ZSH/oh-my-zsh.sh

# User configuration

setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_SPACE
setopt HIST_NO_STORE
setopt HIST_VERIFY
setopt EXTENDED_HISTORY
setopt HIST_SAVE_NO_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_EXPIRE_DUPS_FIRST
setopt AUTO_PUSHD
setopt PUSHD_MINUS
setopt PUSHD_TO_HOME
setopt PUSHD_SILENT
setopt AUTO_NAME_DIRS
setopt PUSHD_IGNORE_DUPS
setopt NUMERIC_GLOB_SORT
setopt EXTENDED_GLOB
setopt COMPLETE_IN_WORD
setopt COMPLETE_ALIASES

# Set title labels to use %d for cwd. Using %~ results in _p9k__cwd instead of
# the real dir due to p10k internals. These variables need to be set _after_
# sourcing omz, otherwise the values will be overridden by termsupport.zsh.
ZSH_THEME_TERM_TAB_TITLE_IDLE="%15<..<%d%<<" #15 char left truncated PWD
#ZSH_THEME_TERM_TITLE_IDLE="%3>.>%n%>>@%3>.>%m%3<.<%m%>>: %12<..<%d%<<"
ZSH_THEME_TERM_TITLE_IDLE="%15<..<%d%<<"

if [ -e '/run/.toolboxenv' ]; then
    ZSH_THEME_TERM_TAB_TITLE_IDLE="🧰${ZSH_THEME_TERM_TAB_TITLE_IDLE}"
    ZSH_THEME_TERM_TITLE_IDLE="🧰${ZSH_THEME_TERM_TITLE_IDLE}"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[ ! -f "${ZSH_CUSTOM}/p10k.zsh" ] || source "${ZSH_CUSTOM}/p10k.zsh"

if [ -z "${LIBVIRT_DEFAULT_URI:-}" ]; then
  export LIBVIRT_DEFAULT_URI='qemu:///system'
fi

for cmd in \
  kubectl \
  talosctl \
  cilium \
  hubble \
  helm \
  flux \
  cosign \
  pomerium-cli \
  kustomize \
  egctl \
  step \
  step-kms-plugin \
  omnictl \
  ; do
  if command -v "${cmd}" &>/dev/null; then
    source <("${cmd}" completion zsh)
  fi
done
