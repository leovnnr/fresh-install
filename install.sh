#!/bin/zsh
# ==============================================================================
# install.sh — Fresh install macOS
# Appelé automatiquement par bootstrap.sh
# ==============================================================================

REPO="$HOME/fresh-install"
BREWFILE="$REPO/Brewfile.txt"
ZSHRC="$REPO/.zshrc"
VSCODE_BIN="/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"
VSCODE_SETTINGS_DIR="$HOME/Library/Application Support/Code/User"

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
echo "✓ Homebrew prêt"


# ------------------------------------------------------------------------------
# 2. Brewfile — installation de toutes les apps
# ------------------------------------------------------------------------------
echo ""
echo "→ Installation des apps via Brewfile..."
echo "  (cette étape peut prendre 20-40 minutes)"
echo ""
brew bundle install --file="$BREWFILE" || true
echo "→ Installation de Claude Code"
echo ""
curl -fsSL https://claude.ai/install.sh | bash
echo "✓ Brewfile terminé"


# ------------------------------------------------------------------------------
# 3. Ghostty — configuration
# ------------------------------------------------------------------------------
echo ""
echo "→ Configuration Ghostty..."
mkdir -p "$HOME/.config/ghostty"
if [ -f "$REPO/ghostty-config" ]; then
  cp "$REPO/ghostty-config" "$HOME/.config/ghostty/config"
  echo "✓ Ghostty configuré"
else
  echo "  ⚠️  ghostty-config introuvable dans le repo"
fi


# ------------------------------------------------------------------------------
# 4. Starship — Tokyo Night
# ------------------------------------------------------------------------------
echo ""
echo "→ Configuration Starship..."
mkdir -p "$HOME/.config"
if [ -f "$REPO/starship.toml" ]; then
  cp "$REPO/starship.toml" "$HOME/.config/starship.toml"
  echo "✓ starship.toml installé"
else
  echo "  ⚠️  starship.toml introuvable dans le repo"
fi


# ------------------------------------------------------------------------------
# 5. .zshrc — copie et activation
# ------------------------------------------------------------------------------
echo ""
echo "→ Installation du .zshrc..."
if [ -f "$HOME/.zshrc" ]; then
  cp "$HOME/.zshrc" "$HOME/.zshrc.backup.$(date +%Y%m%d%H%M%S)"
  echo "  Ancien .zshrc sauvegardé"
fi
if [ -f "$ZSHRC" ]; then
  cp "$ZSHRC" "$HOME/.zshrc"
  echo "✓ .zshrc installé"
else
  echo "  ⚠️  .zshrc introuvable dans le repo"
fi


# ------------------------------------------------------------------------------
# 6. Permissions zsh-completions
# ------------------------------------------------------------------------------
echo ""
echo "→ Correction permissions zsh-completions..."
chmod go-w '/opt/homebrew/share' 2>/dev/null || true
chmod go-w '/opt/homebrew/share/zsh' 2>/dev/null || true
chmod go-w '/opt/homebrew/share/zsh/site-functions' 2>/dev/null || true
echo "✓ Permissions corrigées"


# ------------------------------------------------------------------------------
# 7. VSCode — extension Tokyo Night + settings
# ------------------------------------------------------------------------------
echo ""
echo "→ Configuration VSCode..."
if [ -f "$VSCODE_BIN" ]; then
  "$VSCODE_BIN" --install-extension enkia.tokyo-night
  mkdir -p "$VSCODE_SETTINGS_DIR"
  if [ -f "$VSCODE_SETTINGS_DIR/settings.json" ]; then
    cp "$VSCODE_SETTINGS_DIR/settings.json" \
       "$VSCODE_SETTINGS_DIR/settings.json.backup.$(date +%Y%m%d%H%M%S)"
  fi
  if [ -f "$REPO/vscode-settings.json" ]; then
    cp "$REPO/vscode-settings.json" "$VSCODE_SETTINGS_DIR/settings.json"
    echo "✓ VSCode configuré (Tokyo Night)"
  else
    echo "  ⚠️  vscode-settings.json introuvable dans le repo"
  fi
else
  echo "  ⚠️  VSCode non trouvé dans /Applications"
fi


# ------------------------------------------------------------------------------
# 8. Xcode — accepter la licence
# ------------------------------------------------------------------------------
echo ""
echo "→ Validation licence Xcode..."
sudo xcode-select --install 2>/dev/null || true
sudo xcodebuild -license accept 2>/dev/null || true
echo "✓ Xcode CLT configuré"


# ------------------------------------------------------------------------------
# 9. Rechargement du shell
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
echo "  • Ouvrir Ghostty → vérifier le thème Tokyo Night"
echo "  • Configurer 1Password, puis déverrouiller les autres apps"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
