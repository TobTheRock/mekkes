# mekkes

macOS config with [nix-darwin](https://github.com/nix-darwin/nix-darwin) + [home-manager](https://github.com/nix-community/home-manager) as a darwin module.

- Platform: `aarch64-darwin` (Apple Silicon)
- Flake target: `.#mac`
- System config: `darwin.nix` · user config: `home.nix`

## Setup

| Step | Command |
| --- | --- |
| Install Nix (flakes on) | `curl -fsSL https://install.determinate.systems/nix \| sh -s -- install` |
| Clone | `git clone https://github.com/TobTheRock/mekkes ~/Development/nix/mekkes` |
| First apply (no `darwin-rebuild` yet) | `sudo nix run nix-darwin -- switch --flake .#mac` |
| Apply after that | `sudo darwin-rebuild switch --flake .#mac` |
| Update editor config | `nix flake update nichtsverbessert && sudo darwin-rebuild switch --flake .#mac` |
| List / roll back | `darwin-rebuild --list-generations` · `sudo darwin-rebuild rollback` |

Notes:

- First build compiles Neovim + plugins — takes a few minutes.
- `nix.enable = false` in `darwin.nix`: the Determinate installer manages the nix daemon. Drop it if you install nix another way.
- PATH is handled by nix-darwin's `/etc/zshenv`; no manual export needed.

## Features

| Feature | Details |
| --- | --- |
| Neovim | From [nichtsverbessert](https://github.com/TobTheRock/nichtsverbessert): nixvim, LSP (Nix/Go/Rust/TS/C), Telescope, snacks, dap, neotest, stylix theme |
| Theming | `stylix-minimal` — palette + JetBrains Mono Nerd Font, no desktop targets |
| System | `darwin.nix` — macOS defaults, fonts, homebrew, launchd go here |
