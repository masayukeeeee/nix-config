# Repository structure

This repository is a Nix flake for **nix-darwin** + **home-manager**.

## Top-level

- `flake.nix`
  - Defines `darwinConfigurations.<host>` (nix-darwin entry points).
- `Makefile`
  - Provides a safe workflow (`install` -> `configure` -> `status` -> `apply`) and utilities.
- `Makefile.local` (generated, git-ignored)
  - Per-machine overrides such as `DARWIN_HOST` and `FLAKE_DIR`.

## Key directories

- `hosts/<host>/`
  - `default.nix`: wires together the host modules and enables home-manager users.
  - `darwin.nix`: host-specific nix-darwin settings (system defaults, services, Homebrew, etc.).
- `users/<user>/home.nix`
  - Per-user home-manager config (user identity, home directory, and optional overrides).
- `home/common/`
  - Shared home-manager modules (imports hub, packages, zsh, git, etc.).
- `modules/apps/`
  - App-specific home-manager modules (karabiner/yabai/skhd/nvim/fzf/zsh).
- `files/config/`
  - Static config files that are symlinked into `$XDG_CONFIG_HOME` by home-manager (e.g. Neovim config).
- `docs/`
  - `docs/en`: user-facing documentation (English).
  - `docs/jp`: user-facing documentation (Japanese).
  - `docs/.plans`: internal design notes / plans.

## How host/user wiring works

- Host selection is done via: `darwin-rebuild switch --flake <flakeDir>#<host>`
- Each host enables one or more home-manager users in `hosts/<host>/default.nix` via:
  - `home-manager.users.<user> = import ../../users/<user>/home.nix;`

See also:
- User management: [`docs/en/user-management.md`](user-management.md)
- Make commands: [`docs/en/commands.md`](commands.md)

