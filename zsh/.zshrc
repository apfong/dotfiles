# oh-my-zsh
export ZSH="${HOME}/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-history-substring-search
)
[[ -f "${ZSH}/oh-my-zsh.sh" ]] && source "${ZSH}/oh-my-zsh.sh"

autoload zmv
autoload -U compinit && compinit -i
autoload -U +X bashcompinit && bashcompinit

# --- Generic aliases --------------------------------------------------------
alias k=kubectl
alias prs="gh pr status"

# Git worktree helpers
alias wtl="git worktree list"
alias wtr="git worktree remove"

# wta <slug> [base-branch] — create a worktree under .trees/, symlink .env*
# files from the parent repo, and cd into it. Generic git utility.
wta() {
  local slug="$1"
  local base_branch="${2:-main}"

  if [[ -z "$slug" ]]; then
    echo "Usage: wta <slug> [base-branch]"
    echo "Example: wta my-feature main"
    return 1
  fi

  if [[ -f .gitignore ]] && ! grep -q "^\.trees$" .gitignore; then
    echo ".trees" >> .gitignore
    echo "Added .trees to .gitignore"
  fi

  mkdir -p .trees
  local wt_path=".trees/$slug"

  git worktree add -b "feat/$slug" "$wt_path" "$base_branch" && \
  cd "$wt_path" && \
  for f in ../../.env*; do
    [[ -f "$f" ]] && ln -sf "$f" . && echo "Linked $(basename $f)"
  done
}

# --- History search bindings ------------------------------------------------
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# --- fzf + ripgrep ----------------------------------------------------------
if command -v rg &>/dev/null; then
  export FZF_DEFAULT_COMMAND='rg --files'
  export FZF_DEFAULT_OPTS='-m --height 50% --border'
fi

# --- nvm with .nvmrc auto-switch -------------------------------------------
export NVM_DIR="${HOME}/.nvm"
[[ -s "${NVM_DIR}/nvm.sh" ]] && source "${NVM_DIR}/nvm.sh"
[[ -s "${NVM_DIR}/bash_completion" ]] && source "${NVM_DIR}/bash_completion"

if command -v nvm &>/dev/null; then
  autoload -U add-zsh-hook
  load-nvmrc() {
    local nvmrc_path
    nvmrc_path="$(nvm_find_nvmrc)"

    if [[ -n "$nvmrc_path" ]]; then
      local nvmrc_node_version
      nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")
      if [[ "$nvmrc_node_version" = "N/A" ]]; then
        nvm install
      elif [[ "$nvmrc_node_version" != "$(nvm version)" ]]; then
        nvm use
      fi
    elif [[ -n "$(PWD=$OLDPWD nvm_find_nvmrc)" ]] && [[ "$(nvm version)" != "$(nvm version default)" ]]; then
      echo "Reverting to nvm default version"
      nvm use default
    fi
  }
  add-zsh-hook chpwd load-nvmrc
  load-nvmrc
fi

# --- Bun --------------------------------------------------------------------
if [[ -d "${HOME}/.bun" ]]; then
  export BUN_INSTALL="${HOME}/.bun"
  export PATH="${BUN_INSTALL}/bin:$PATH"
  [[ -s "${HOME}/.bun/_bun" ]] && source "${HOME}/.bun/_bun"
fi

# --- Cargo / Rust -----------------------------------------------------------
[[ -f "${HOME}/.cargo/env" ]] && source "${HOME}/.cargo/env"

# --- Foundry ----------------------------------------------------------------
[[ -d "${HOME}/.foundry/bin" ]] && export PATH="${HOME}/.foundry/bin:$PATH"

# --- Solana -----------------------------------------------------------------
[[ -d "${HOME}/.local/share/solana/install/active_release/bin" ]] && \
  export PATH="${HOME}/.local/share/solana/install/active_release/bin:$PATH"

# --- ~/.local/bin -----------------------------------------------------------
[[ -d "${HOME}/.local/bin" ]] && export PATH="${HOME}/.local/bin:$PATH"

# --- Terraform completion ---------------------------------------------------
if command -v terraform &>/dev/null; then
  complete -o nospace -C "$(command -v terraform)" terraform
fi

# --- Conda (if installed) ---------------------------------------------------
if [[ -f "${HOME}/miniconda3/etc/profile.d/conda.sh" ]]; then
  source "${HOME}/miniconda3/etc/profile.d/conda.sh"
elif [[ -f "${HOME}/anaconda3/etc/profile.d/conda.sh" ]]; then
  source "${HOME}/anaconda3/etc/profile.d/conda.sh"
fi

# --- Nix --------------------------------------------------------------------
if [[ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]]; then
  source '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi

# --- macOS-only -------------------------------------------------------------
if [[ "$OSTYPE" == darwin* ]]; then
  # Fix tmux 256color rendering
  alias tmux="TERM=screen-256color-bce tmux"

  # gcloud SDK (Mac install location)
  if [[ -d "${HOME}/Downloads/google-cloud-sdk" ]]; then
    [[ -f "${HOME}/Downloads/google-cloud-sdk/path.zsh.inc" ]]       && source "${HOME}/Downloads/google-cloud-sdk/path.zsh.inc"
    [[ -f "${HOME}/Downloads/google-cloud-sdk/completion.zsh.inc" ]] && source "${HOME}/Downloads/google-cloud-sdk/completion.zsh.inc"
  fi

  # Windsurf
  [[ -d "${HOME}/.codeium/windsurf/bin" ]] && export PATH="${HOME}/.codeium/windsurf/bin:$PATH"

  # Antigravity
  [[ -d "${HOME}/.antigravity/antigravity/bin" ]] && export PATH="${HOME}/.antigravity/antigravity/bin:$PATH"
fi

# --- Local + machine-specific extensions -----------------------------------
# ~/.zshrc.local — personal/work-specific overrides not in this repo.
# ~/.zshrc.plural — Plural Energy team aliases (synced separately to dev VMs).
[[ -f "${HOME}/.zshrc.local" ]]  && source "${HOME}/.zshrc.local"
[[ -f "${HOME}/.zshrc.plural" ]] && source "${HOME}/.zshrc.plural"
