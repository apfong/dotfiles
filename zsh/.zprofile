# macOS-only login-shell init.
if [[ "$OSTYPE" == darwin* ]]; then
  # OrbStack: command-line tools and integration
  [[ -f "${HOME}/.orbstack/shell/init.zsh" ]] && source "${HOME}/.orbstack/shell/init.zsh"
fi
