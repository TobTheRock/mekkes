# mekkes

Standalone [home-manager](https://github.com/nix-community/home-manager) config for macOS — no nix-darwin, no system-level changes. Goal: a Mac that works like the Linux box next to it (same editor, colors, keybindings, pinned versions).

- Platform: `aarch64-darwin` (Apple Silicon)
- Flake target: `.#tobi@mac`

## Setup

| Step | Command |
|---|---|
| Install Nix (flakes on) | `curl -fsSL https://install.determinate.systems/nix \| sh -s -- install` |
| Clone | `git clone https://github.com/TobTheRock/mekkes ~/Development/nix/mekkes` |
| Apply | `nix run home-manager -- switch --flake .#tobi@mac` |
| Update editor config | `nix flake update nichtsverbessert && nix run home-manager -- switch --flake .#tobi@mac` |
| List/roll back | `home-manager generations` |

Notes:

- First build compiles Neovim + plugins — takes a few minutes.
- Binaries land in `~/.nix-profile/bin`. If `nvim` is not found:
  `echo 'export PATH="$HOME/.nix-profile/bin:$PATH"' >> ~/.zshrc`

## Features

| Feature | Details |
|---|---|
| Neovim | From [nichtsverbessert](https://github.com/TobTheRock/nichtsverbessert): nixvim, LSP (Nix/Go/Rust/TS/C), Telescope, snacks, dap, neotest, stylix theme |
| Theming | `stylix-minimal` — palette + JetBrains Mono Nerd Font, no desktop targets |
