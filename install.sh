#!/bin/zsh
# ==============================================================================
# install.sh — Fresh install macOS
# Usage : zsh install.sh
#
# Appelé automatiquement par bootstrap.sh
# ==============================================================================

tap "homebrew/cask-fonts"
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
brew bundle install --file="$BREWFILE" || true
echo ""
echo "✓ Brewfile terminé"


# ------------------------------------------------------------------------------
# 3. Ghostty — configuration
# ------------------------------------------------------------------------------
echo ""
echo "→ Configuration Ghostty..."
mkdir -p "$HOME/.config/ghostty"
cp "$REPO/ghostty-config" "$HOME/.config/ghostty/config"
echo "✓ Ghostty configuré (Tokyo Night, MesloLGS Nerd Font Mono)"


# ------------------------------------------------------------------------------
# 4. Starship — preset Tokyo Night
# ------------------------------------------------------------------------------
echo ""
echo "→ Configuration Starship (Tokyo Night)..."
mkdir -p "$HOME/.config"
cp "$REPO/starship.toml" "$HOME/.config/starship.toml"
echo "✓ starship.toml installé"


# ------------------------------------------------------------------------------
# 5. .zshrc — copie et activation
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
# 6. VSCode — extension Tokyo Night + settings
# ------------------------------------------------------------------------------
echo ""
echo "→ Configuration VSCode..."

VSCODE_BIN="/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"
VSCODE_SETTINGS_DIR="$HOME/Library/Application Support/Code/User"

if [ -f "$VSCODE_BIN" ]; then
  "$VSCODE_BIN" --install-extension enkia.tokyo-night
  echo "  Extension Tokyo Night installée"

  mkdir -p "$VSCODE_SETTINGS_DIR"

  if [ -f "$VSCODE_SETTINGS_DIR/settings.json" ]; then
    cp "$VSCODE_SETTINGS_DIR/settings.json" \
       "$VSCODE_SETTINGS_DIR/settings.json.backup.$(date +%Y%m%d%H%M%S)"
    echo "  Anciens settings VSCode sauvegardés"
  fi

  cp "$REPO/vscode-settings.json" "$VSCODE_SETTINGS_DIR/settings.json"
  echo "✓ VSCode configuré (Tokyo Night + MesloLGS Nerd Font Mono)"
else
  echo "  ⚠️  VSCode non trouvé dans /Applications — vérifier l'installation"
fi


# ------------------------------------------------------------------------------
# 7. macOS — accepter la licence Xcode
# ------------------------------------------------------------------------------
echo ""
echo "→ Validation licence Xcode Command Line Tools..."
sudo xcode-select --install 2>/dev/null || true
sudo xcodebuild -license accept 2>/dev/null || true
echo "✓ Xcode CLT configuré"


# ------------------------------------------------------------------------------
# 8. Rechargement du shell
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
echo "  • Ouvrir Ghostty et VSCode → vérifier le thème Tokyo Night"
echo "  • Configurer 1Password, puis déverrouiller les autres apps"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
