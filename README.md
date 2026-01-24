# nix-config

Personal macOS configuration based on **nix-darwin** + **home-manager**, managed as a Nix flake.

- Japanese README: [`README_JP.md`](README_JP.md)
- Docs (EN):
  - Repository structure: [`docs/en/structure.md`](docs/en/structure.md)
  - User management (add/remove): [`docs/en/user-management.md`](docs/en/user-management.md)
  - Make commands: [`docs/en/commands.md`](docs/en/commands.md)

## Overview

- **Hosts** are defined under `hosts/<host>/` and exposed via `flake.nix` as `darwinConfigurations.<host>`.
- **Users** are defined under `users/<user>/home.nix` and enabled per-host in `hosts/<host>/default.nix` via `home-manager.users.<user> = import ...;`.
- The recommended workflow uses the root `Makefile` and a per-machine `Makefile.local` (ignored by git).

## Quick start (install -> apply)

1. Install Nix (Determinate Nix Installer):

```bash
make install
```

2. If `nix` is not yet in your PATH, open a new shell or source one of the scripts suggested by `make install`.

3. Create `Makefile.local` (sets `DARWIN_HOST` to your current hostname):

```bash
make configure
```

4. Verify status:

```bash
make status
```

5. Apply configuration:

```bash
make apply
```

## User add/remove

See: [`docs/en/user-management.md`](docs/en/user-management.md)

## Uninstall

This uninstalls Nix if it was installed via Determinate:

```bash
make uninstall
```

Notes:
- This may require `sudo`.
- `make uninstall` will error if `/nix/nix-installer` is not found.
- Visual Studio Code
  - If you don't have properly fonts, garbled characters could be displayed in terminals in vscode.
  - When it happend, please add `MesloLGS NF` into fonts in terminal setting.
