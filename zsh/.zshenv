# Loaded for all zsh invocations (including non-interactive). Keep this
# file fast and side-effect-free — only env vars and minimal PATH bumps.

# Cargo / Rust
[[ -f "${HOME}/.cargo/env" ]] && source "${HOME}/.cargo/env"

# Foundry
[[ -d "${HOME}/.foundry/bin" ]] && export PATH="${HOME}/.foundry/bin:$PATH"
