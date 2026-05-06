# dotfiles

zsh, tmux, vim, git, and ripgrep configs. Works on macOS and Linux — the configs guard mac-only bits with `[[ "$OSTYPE" == darwin* ]]` / `if-shell '[ "$(uname)" = "Darwin" ]'`, so the same files run cleanly on a headless Linux box.

## Install

```bash
git clone https://github.com/apfong/dotfiles.git ~/dotfiles
~/dotfiles/install.sh
```

`install.sh` auto-detects the profile (`full` on Darwin, `server` on Linux), backs up any existing files to `<file>.bak.<timestamp>`, symlinks new ones, and installs oh-my-zsh + zsh plugins + Vundle + tpm.

Force a profile:

```bash
~/dotfiles/install.sh --profile=server   # zsh + tmux + vim + git + ripgrep
~/dotfiles/install.sh --profile=full     # server + vscode user settings (mac)
```

After install, open a new shell (or `exec zsh`).

## Layered config — local + work overrides

The `.zshrc` sources two optional files at the end so you can keep machine- or work-specific bits out of this public repo:

- `~/.zshrc.local` — personal/machine-specific overrides (e.g. work emails, private API keys, anything you don't want public)
- `~/.zshrc.plural` — Plural Energy team aliases (`kshell-*`, etc.); synced separately to dev VMs

The `.gitconfig` does the same: it `[include]`s `~/.gitconfig.local` so personal git settings (e.g. signing keys, the `[url] insteadOf` SSH rewrite that's useful on a laptop with SSH keys but breaks on dev VMs) live outside this repo.

## Layout

```
zsh/      .zshrc, .zprofile, .zshenv
tmux/     .tmux.conf
vim/      .vimrc
git/      .gitconfig, .gitignore_global
vscode/   settings.json, extensions.txt   (full profile only, Mac)
.ripgreprc, .rgignore
install.sh
```

## Vim plugin notes

`install.sh` runs `:PluginInstall` once at the end. To update later:

```vim
:PluginUpdate
:PluginClean
```

## tmux plugin notes

`tpm` is auto-installed by `install.sh`. Inside tmux, refresh plugins with `prefix + I`. Save/restore sessions with `prefix + C-s` / `prefix + C-r` (tmux-resurrect).
