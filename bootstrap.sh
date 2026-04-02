#!/bin/zsh
# ==============================================================================
# bootstrap.sh — Fresh install macOS
#
# Une seule commande à taper sur une nouvelle machine :
# curl -fsSL https://raw.githubusercontent.com/leovnnr/fresh-install/main/bootstrap.sh -o /tmp/bootstrap.sh && zsh /tmp/bootstrap.sh
# ==============================================================================

set -e

REPO_URL="https://github.com/leovnnr/fresh-install.git"
REPO_DIR="$HOME/fresh-install"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Bootstrap — Fresh install macOS"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""


# ------------------------------------------------------------------------------
# 1. Homebrew
# ------------------------------------------------------------------------------
echo "→ Installation de Homebrew..."

if command -v brew &>/dev/null; then
  echo "  Homebrew déjà installé, on passe."
else
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

eval "$(/opt/homebrew/bin/brew shellenv)"
echo "✓ Homebrew prêt"


# ------------------------------------------------------------------------------
# 2. gh — GitHub CLI
# ------------------------------------------------------------------------------
echo ""
echo "→ Installation de gh (GitHub CLI)..."

if command -v gh &>/dev/null; then
  echo "  gh déjà installé, on passe."
else
  brew install gh
fi

# Recharger le PATH après brew install (nécessaire hors pipe)
eval "$(/opt/homebrew/bin/brew shellenv)"
echo "✓ gh installé"


# ------------------------------------------------------------------------------
# 3. Authentification GitHub
# ------------------------------------------------------------------------------
echo ""
echo "→ Authentification GitHub..."
echo "  (un navigateur va s'ouvrir pour valider)"
echo ""

if gh auth status &>/dev/null; then
  echo "  Déjà authentifié, on passe."
else
  gh auth login --web --git-protocol https
fi

echo "✓ GitHub authentifié"


# ------------------------------------------------------------------------------
# 4. Clone du repo fresh-install
# ------------------------------------------------------------------------------
echo ""
echo "→ Clonage du repo fresh-install..."

if [ -d "$REPO_DIR" ]; then
  echo "  Repo déjà présent, mise à jour..."
  git -C "$REPO_DIR" pull
else
  # git clone HTTPS plutôt que gh repo clone — fonctionne sans stdin
  git clone "$REPO_URL" "$REPO_DIR"
fi

echo "✓ Repo cloné dans $REPO_DIR"


# ------------------------------------------------------------------------------
# 5. Lancement de install.sh
# ------------------------------------------------------------------------------
echo ""
echo "→ Lancement de install.sh..."
echo ""

chmod +x "$REPO_DIR/install.sh"
zsh "$REPO_DIR/install.sh"
