# User management (add/remove)

This repo distinguishes:

- **home-manager users**: `users/<user>/home.nix` (dotfiles, CLI tools, shell config, etc.)
- **macOS system users**: `users.users.<name>` in `hosts/<host>/darwin.nix` (actual macOS account settings)

Most of the time, when you “add a user” here, you mean adding a **home-manager user**.

## Add a home-manager user

### 1) Create `users/<newUser>/home.nix`

Create a new file, e.g. `users/alice/home.nix`:

```nix
{ ... }: {
  imports = [
    ../../home/common/default.nix
  ];

  home.username = "alice";
  home.homeDirectory = "/Users/alice";
  home.stateVersion = "24.05";

  # Optional: per-user git identity
  programs.git.settings.user = { name = "Alice"; email = "alice@example.com"; };
}
```

### 2) Enable the user on a host

Edit the target host `hosts/<host>/default.nix` and add:

```nix
home-manager.users.alice = import ../../users/alice/home.nix;
```

Example pattern already used in this repo:
- `hosts/2023-X0160/default.nix` enables `home-manager.users.msakai`
- `hosts/MasayukiSakainoMacBook-Air/default.nix` enables `home-manager.users.masayukisakai`

### 3) Apply

```bash
make status
make apply
```

## Remove a home-manager user

1) Remove the entry from `hosts/<host>/default.nix`, for example:

```nix
# home-manager.users.alice = import ../../users/alice/home.nix;
```

2) (Optional) delete `users/<user>/home.nix`

3) Apply:

```bash
make apply
```

## If you need to manage macOS system users

That is separate from home-manager and is configured per-host in `hosts/<host>/darwin.nix`, e.g.:

```nix
users.users.<name> = {
  home = "/Users/<name>";
  description = "<host>";
};
```

Be careful: creating/removing real macOS accounts is an OS-level concern.

