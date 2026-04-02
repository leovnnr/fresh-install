#!/bin/zsh
# ==============================================================================
# install.sh — Fresh install macOS
# Usage : zsh install.sh
#
# Prérequis manuels AVANT de lancer ce script :
#   1. Installer Homebrew :
#      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
#   2. Installer gh et s'authentifier :
#      brew install gh && gh auth login
#   3. Cloner le repo :
#      git clone https://github.com/leovnnr/fresh-install.git ~/fresh-install
#   4. Lancer ce script :
#      zsh ~/fresh-install/install.sh
# ==============================================================================

set -e  # stopper en cas d'erreur

REPO="$HOME/fresh-install"
BREWFILE="$REPO/Brewfile.txt"
ZSHRC="$REPO/.zshrc"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Fresh install macOS — démarrage"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""


# ------------------------------------------------------------------------------
# 1. Homebrew — PATH Apple Silicon
# ------------------------------------------------------------------------------
echo "→ Configuration Homebrew..."
eval "$(/opt/homebrew/bin/brew shellenv)"


# ------------------------------------------------------------------------------
# 2. Brewfile — installation de toutes les apps
# ------------------------------------------------------------------------------
echo ""
echo "→ Installation des apps via Brewfile..."
echo "  (cette étape peut prendre 20-40 minutes)"
echo ""
brew bundle install --file="$BREWFILE"
echo ""
echo "✓ Brewfile terminé"


# ------------------------------------------------------------------------------
# 3. .zshrc — copie et activation
# ------------------------------------------------------------------------------
echo ""
echo "→ Installation du .zshrc..."

if [ -f "$HOME/.zshrc" ]; then
  cp "$HOME/.zshrc" "$HOME/.zshrc.backup.$(date +%Y%m%d%H%M%S)"
  echo "  Ancien .zshrc sauvegardé dans ~/.zshrc.backup.*"
fi

cp "$ZSHRC" "$HOME/.zshrc"
echo "✓ .zshrc installé"


# ------------------------------------------------------------------------------
# 4. macOS — accepter la licence Xcode
# ------------------------------------------------------------------------------
echo ""
echo "→ Validation licence Xcode Command Line Tools..."
sudo xcode-select --install 2>/dev/null || true
sudo xcodebuild -license accept 2>/dev/null || true
echo "✓ Xcode CLT configuré"


# ------------------------------------------------------------------------------
# 5. Rechargement du shell
# ------------------------------------------------------------------------------
echo ""
echo "→ Rechargement du shell..."
source "$HOME/.zshrc" 2>/dev/null || true


# ------------------------------------------------------------------------------
# Fin
# ------------------------------------------------------------------------------
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  ✓ Installation terminée !"
echo ""
echo "  Étapes manuelles restantes :"
echo "  • Réglages Système → Confidentialité → autoriser MacFUSE"
echo "  • Lancer Xcode une première fois pour finaliser"
echo "  • Configurer 1Password, puis déverrouiller les autres apps"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
