# Make commands

This repo provides a `Makefile` at the repository root.

## Common workflow

```bash
make install
make configure
make status
make apply
```

## Targets

- `make install`
  - Installs Nix via Determinate Nix Installer (`curl | sh`).
- `make uninstall`
  - Uninstalls Nix via `/nix/nix-installer uninstall` (if present).
- `make configure`
  - Writes `Makefile.local` (git-ignored) with:
    - `FLAKE_DIR := <repo root>`
    - `DARWIN_HOST := <current host name>`
- `make status`
  - Pretty “ready to apply” checks; optionally uses pager when `USE_PAGER=1`.
- `make status-body`
  - Raw status output (what `status` wraps).
- `make show-config`
  - Prints effective values of `FLAKE_DIR`, `DARWIN_HOST`, etc., and override examples.
- `make apply`
  - Runs `sudo darwin-rebuild switch --flake $(FLAKE_DIR)#$(DARWIN_HOST)` after safety checks.
- `make cleanup-safety`
  - Runs `nix store gc` and `nix store optimise` (does **not** delete generations).
- `make cleanup-all`
  - Runs `nix-collect-garbage -d` and `nix store optimise` (aggressive).

## Variables (overrides)

You can override these via `Makefile.local` or on the command line:

- `FLAKE_DIR`
  - Defaults to the repo root (directory containing the `Makefile`).
  - Must contain `flake.nix`.
- `DARWIN_HOST`
  - Target host name (must exist as `hosts/<DARWIN_HOST>/default.nix` and in flake `darwinConfigurations`).
- `REQUIRE_LOCAL`
  - Defaults to `1`. When enabled, `make apply` requires `Makefile.local` for safety.
  - You can bypass with: `make apply REQUIRE_LOCAL=0 DARWIN_HOST=<host>`
- `USE_PAGER`
  - Defaults to `0`. When set to `1`, `make status` may pipe through `less -R`.
- `NIX_FLAKE`
  - Nix command used for flake evaluation, defaults to:
    - `nix --extra-experimental-features nix-command --extra-experimental-features flakes`

## Typical errors & fixes

- `ERROR: Makefile.local is required before apply`
  - Run: `make configure`
  - Or bypass: `make apply REQUIRE_LOCAL=0 DARWIN_HOST=<host>`
- `ERROR: DARWIN_HOST is empty`
  - Run: `make configure`
  - Or set explicitly: `make apply DARWIN_HOST=<host> REQUIRE_LOCAL=0`
- `ERROR: host module not found: hosts/<host>/default.nix`
  - Check available hosts: `ls hosts/`
- `ERROR: nix not found in PATH`
  - Open a new shell or source the profile script suggested by `make install`.

