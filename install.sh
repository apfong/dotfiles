#!/usr/bin/env bash
# Install Alex's dotfiles. Idempotent — safe to re-run.
#
# Usage:
#   ./install.sh                  # auto-detect profile (full on darwin, server on linux)
#   ./install.sh --profile=server # terminal-only: zsh, tmux, vim, git, ripgrep
#   ./install.sh --profile=full   # server + vscode user settings (Mac)
#
# Existing files are backed up to <file>.bak.<timestamp> on first install.

set -euo pipefail

# --- profile detection ------------------------------------------------------
PROFILE=""
for arg in "$@"; do
  case "$arg" in
    --profile=*) PROFILE="${arg#--profile=}" ;;
    -h|--help)
      sed -n '/^# Usage:/,/^$/p' "$0" | sed 's/^# //;s/^#//'
      exit 0
      ;;
    *) echo "Unknown arg: $arg" >&2; exit 1 ;;
  esac
done

if [[ -z "$PROFILE" ]]; then
  case "$(uname -s)" in
    Darwin) PROFILE=full   ;;
    Linux)  PROFILE=server ;;
    *)      PROFILE=server ;;
  esac
fi

if [[ "$PROFILE" != "server" && "$PROFILE" != "full" ]]; then
  echo "Invalid --profile=$PROFILE. Use 'server' or 'full'." >&2
  exit 1
fi

REPO="$(cd "$(dirname "$0")" && pwd)"
TS="$(date +%Y%m%d-%H%M%S)"

echo "==> Installing dotfiles from ${REPO}"
echo "==> Profile: ${PROFILE} (OS: $(uname -s))"

# --- 0) Install OS dependencies --------------------------------------------
# Tools the configs assume exist: zsh, tmux, vim, git, ripgrep, fzf.
# Linux: apt-get (Debian/Ubuntu only). Mac: rely on brew if any are missing.
install_deps_linux() {
  local missing=()
  for cmd in zsh tmux vim git rg fzf; do
    command -v "$cmd" &>/dev/null || missing+=("$cmd")
  done
  if [[ ${#missing[@]} -eq 0 ]]; then
    echo "  [ok  ] zsh tmux vim git ripgrep fzf"
    return
  fi
  echo "  Missing: ${missing[*]} — installing via apt-get..."
  # Map command names to apt package names where they differ.
  local pkgs=()
  for cmd in "${missing[@]}"; do
    case "$cmd" in
      rg) pkgs+=("ripgrep") ;;
      *)  pkgs+=("$cmd") ;;
    esac
  done
  sudo apt-get update -qq
  sudo apt-get install -y -qq "${pkgs[@]}"
}

install_deps_mac() {
  local missing=()
  for cmd in zsh tmux vim git rg fzf; do
    command -v "$cmd" &>/dev/null || missing+=("$cmd")
  done
  if [[ ${#missing[@]} -eq 0 ]]; then
    echo "  [ok  ] zsh tmux vim git ripgrep fzf"
    return
  fi
  if ! command -v brew &>/dev/null; then
    echo "ERROR: missing ${missing[*]} and no brew to install them. Install Homebrew first: https://brew.sh" >&2
    exit 1
  fi
  echo "  Missing: ${missing[*]} — installing via brew..."
  local pkgs=()
  for cmd in "${missing[@]}"; do
    case "$cmd" in
      rg) pkgs+=("ripgrep") ;;
      *)  pkgs+=("$cmd") ;;
    esac
  done
  brew install "${pkgs[@]}"
}

echo "==> Checking OS dependencies..."
case "$(uname -s)" in
  Linux)  install_deps_linux ;;
  Darwin) install_deps_mac   ;;
esac

# --- helper: symlink with backup -------------------------------------------
link() {
  local src="$1" dst="$2"
  if [[ -L "$dst" && "$(readlink "$dst")" == "$src" ]]; then
    printf '  [ok  ] %s\n' "$dst"
    return
  fi
  if [[ -e "$dst" || -L "$dst" ]]; then
    mv "$dst" "${dst}.bak.${TS}"
    printf '  [back] %s -> %s.bak.%s\n' "$dst" "$dst" "$TS"
  fi
  mkdir -p "$(dirname "$dst")"
  ln -s "$src" "$dst"
  printf '  [link] %s -> %s\n' "$dst" "$src"
}

# --- 1) Symlink config files -----------------------------------------------
echo "==> Symlinking config files..."
link "${REPO}/zsh/.zshrc"             "${HOME}/.zshrc"
link "${REPO}/zsh/.zprofile"          "${HOME}/.zprofile"
link "${REPO}/zsh/.zshenv"            "${HOME}/.zshenv"
link "${REPO}/tmux/.tmux.conf"        "${HOME}/.tmux.conf"
link "${REPO}/vim/.vimrc"             "${HOME}/.vimrc"
link "${REPO}/git/.gitignore_global"  "${HOME}/.gitignore_global"

# Don't symlink .gitconfig — it usually has user-set bits we don't want to
# clobber (email, gh credential helper, signing keys). Instead, pull just
# the [alias] section out of the repo's .gitconfig and apply each via
# `git config --global` — idempotent, only touches aliases.
echo "==> Applying git aliases from ${REPO}/git/.gitconfig..."
git config --file "${REPO}/git/.gitconfig" --get-regexp '^alias\.' | while read -r key value; do
  git config --global "$key" "$value"
  printf '  [set ] %s\n' "$key"
done

# ripgrep configs (root of repo)
[[ -f "${REPO}/.ripgreprc" ]] && link "${REPO}/.ripgreprc" "${HOME}/.ripgreprc"
[[ -f "${REPO}/.rgignore"  ]] && link "${REPO}/.rgignore"  "${HOME}/.rgignore"

# --- 2) oh-my-zsh + plugins ------------------------------------------------
if [[ ! -d "${HOME}/.oh-my-zsh" ]]; then
  echo "==> Installing oh-my-zsh..."
  RUNZSH=no CHSH=no \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

ZSH_CUSTOM="${HOME}/.oh-my-zsh/custom"
clone_plugin() {
  local name="$1" url="$2"
  local dst="${ZSH_CUSTOM}/plugins/${name}"
  if [[ -d "$dst/.git" ]]; then
    printf '  [ok  ] zsh plugin: %s\n' "$name"
  else
    git clone --quiet "$url" "$dst" && printf '  [add ] zsh plugin: %s\n' "$name"
  fi
}
echo "==> Installing zsh plugins..."
clone_plugin zsh-autosuggestions          https://github.com/zsh-users/zsh-autosuggestions
clone_plugin zsh-syntax-highlighting      https://github.com/zsh-users/zsh-syntax-highlighting
clone_plugin zsh-history-substring-search https://github.com/zsh-users/zsh-history-substring-search

# --- 3) Vundle for vim ----------------------------------------------------
if [[ ! -d "${HOME}/.vim/bundle/Vundle.vim" ]]; then
  echo "==> Installing Vundle..."
  git clone --quiet https://github.com/VundleVim/Vundle.vim.git "${HOME}/.vim/bundle/Vundle.vim"
fi
if command -v vim &>/dev/null; then
  echo "==> Running :PluginInstall (this may take a minute)..."
  vim -es -u "${HOME}/.vimrc" -i NONE -c "PluginInstall" -c "qa" || true
fi

# --- 4) tpm for tmux ------------------------------------------------------
if [[ ! -d "${HOME}/.tmux/plugins/tpm" ]]; then
  echo "==> Installing tpm..."
  git clone --quiet https://github.com/tmux-plugins/tpm "${HOME}/.tmux/plugins/tpm"
  "${HOME}/.tmux/plugins/tpm/bin/install_plugins" 2>/dev/null || true
fi

# --- 5) Full-profile-only: VS Code user settings -------------------------
if [[ "$PROFILE" == "full" && "$(uname -s)" == "Darwin" ]]; then
  VSCODE_USER="${HOME}/Library/Application Support/Code/User"
  if [[ -d "${VSCODE_USER}" ]]; then
    echo "==> Installing VS Code user settings..."
    if [[ -f "${VSCODE_USER}/settings.json" && ! -L "${VSCODE_USER}/settings.json" ]]; then
      mv "${VSCODE_USER}/settings.json" "${VSCODE_USER}/settings.json.bak.${TS}"
    fi
    ln -sf "${REPO}/vscode/settings.json" "${VSCODE_USER}/settings.json"
    echo "  [link] ${VSCODE_USER}/settings.json"
    echo "  Tip: install extensions from vscode/extensions.txt with:"
    echo "    cat ${REPO}/vscode/extensions.txt | xargs -L 1 code --install-extension"
  else
    echo "==> Skipping VS Code (Code user dir not found)"
  fi
fi

echo
echo "==> Done."
echo "Open a new shell (or run 'exec zsh') to pick up the changes."
if [[ "$(basename "${SHELL:-}")" != "zsh" ]] && command -v zsh &>/dev/null; then
  # `sudo chsh ... $USER` works everywhere; bare `chsh` hits PAM and fails on
  # headless Linux VMs where the user account has no password set.
  echo "Set zsh as your default shell with: sudo chsh -s \$(which zsh) \$USER"
fi
