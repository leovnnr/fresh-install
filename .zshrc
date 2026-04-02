# ==============================================================================
# .zshrc — Configuration Zsh + Starship
# Fresh install macOS
#
# Usage :
#   git clone https://github.com/leovnnr/fresh-install.git ~/fresh-install
#   cp ~/fresh-install/.zshrc ~/.zshrc && source ~/.zshrc
# ==============================================================================


# ------------------------------------------------------------------------------
# Starship — prompt
# ------------------------------------------------------------------------------
eval "$(starship init zsh)"


# ------------------------------------------------------------------------------
# Plugins Homebrew
# ------------------------------------------------------------------------------
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fpath+=$(brew --prefix)/share/zsh-completions
autoload -Uz compinit && compinit

# ------------------------------------------------------------------------------
# Fix compatibilité Ghostty en SSH
# ------------------------------------------------------------------------------
if [[ -n "$SSH_CONNECTION" ]]; then
  export TERM=xterm-256color
fi


# ------------------------------------------------------------------------------
# zoxide — remplace cd
# Usage : z nom_dossier
# ------------------------------------------------------------------------------
eval "$(zoxide init zsh)"


# ------------------------------------------------------------------------------
# pyenv — gestion versions Python
# ------------------------------------------------------------------------------
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"


# ------------------------------------------------------------------------------
# nvm — gestion versions Node
# ------------------------------------------------------------------------------
export NVM_DIR="$HOME/.nvm"
[ -s "$(brew --prefix nvm)/nvm.sh" ] && source "$(brew --prefix nvm)/nvm.sh"
[ -s "$(brew --prefix nvm)/etc/bash_completion.d/nvm" ] && source "$(brew --prefix nvm)/etc/bash_completion.d/nvm"


# ------------------------------------------------------------------------------
# Aliases
# ------------------------------------------------------------------------------

# Fichiers & navigation
alias ls="eza --icons --git"
alias ll="eza -la --icons --git"
alias la="eza -a --icons"
alias lt="eza --tree --icons --git-ignore"
alias cat="bat --paging=never"
alias find="fd"
alias grep="rg"
alias cd="z"

# Git
alias g="git"
alias gs="git status"
alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias gl="git pull"
alias glog="git log --oneline --graph --decorate"
alias lg="lazygit"

# Réseau & serveurs
alias ip="curl ifconfig.me"                          # IP publique
alias localip="ipconfig getifaddr en0"               # IP locale
alias ssh1="ssh leo@192.168.1.27"                    # Ubuntu — réseau local
alias ssh2="ssh leo@100.120.245.29"                  # Ubuntu — Tailscale

# Système
alias reload="source ~/.zshrc"
alias zshrc="$EDITOR ~/.zshrc"
alias up="topgrade"
alias top="htop"

# Utilitaires
alias json="jq ."                                    # pretty print JSON
alias tree="tree -C"


# ------------------------------------------------------------------------------
# Git — configuration delta pour les diffs
# ------------------------------------------------------------------------------
export GIT_PAGER="delta"


# ------------------------------------------------------------------------------
# Historique Zsh — paramètres étendus
# ------------------------------------------------------------------------------
HISTSIZE=50000
SAVEHIST=50000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_DUPS       # pas de doublons consécutifs
setopt HIST_IGNORE_SPACE      # ignorer les commandes préfixées d'un espace
setopt SHARE_HISTORY          # partager l'historique entre sessions
setopt EXTENDED_HISTORY       # horodatage dans l'historique


# ------------------------------------------------------------------------------
# Divers
# ------------------------------------------------------------------------------
setopt AUTO_CD                # taper un dossier sans `cd` pour y aller
setopt CORRECT                # suggestion si commande mal orthographiée
export EDITOR="code"          # VSCode comme éditeur par défaut
export LANG="fr_FR.UTF-8"
export LC_ALL="fr_FR.UTF-8"


# ------------------------------------------------------------------------------
# PATH — priorité aux binaires Homebrew (Apple Silicon)
# ------------------------------------------------------------------------------
export PATH="/opt/homebrew/bin:$PATH"
