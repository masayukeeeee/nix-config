# ユーザー管理（追加/削除）

このリポジトリでは、次の2種類を区別します。

- **home-manager ユーザー**: `users/<user>/home.nix`（dotfiles/CLI/shell など）
- **macOS の実ユーザー**: `hosts/<host>/darwin.nix` の `users.users.<name>`（OS のユーザーアカウント）

多くの場合「ユーザーを追加する」は **home-manager ユーザーを追加する**ことを指します。

## home-manager ユーザーを追加する

### 1) `users/<newUser>/home.nix` を作る

例: `users/alice/home.nix`

```nix
{ ... }: {
  imports = [
    ../../home/common/default.nix
  ];

  home.username = "alice";
  home.homeDirectory = "/Users/alice";
  home.stateVersion = "24.05";

  # 任意: ユーザーごとの git identity
  programs.git.settings.user = { name = "Alice"; email = "alice@example.com"; };
}
```

### 2) 対象ホストで有効化する

対象ホストの `hosts/<host>/default.nix` に以下を追加します。

```nix
home-manager.users.alice = import ../../users/alice/home.nix;
```

このリポジトリの既存例:
- `hosts/2023-X0160/default.nix` は `home-manager.users.msakai` を有効化
- `hosts/MasayukiSakainoMacBook-Air/default.nix` は `home-manager.users.masayukisakai` を有効化

### 3) 反映する

```bash
make status
make apply
```

## home-manager ユーザーを削除する

1) `hosts/<host>/default.nix` から該当行を削除（またはコメントアウト）します。

```nix
# home-manager.users.alice = import ../../users/alice/home.nix;
```

2)（任意）`users/<user>/home.nix` を削除します

3) 反映:

```bash
make apply
```

## macOS の実ユーザー（OSアカウント）を扱う場合

home-manager とは別で、ホストごとに `hosts/<host>/darwin.nix` で設定します。例:

```nix
users.users.<name> = {
  home = "/Users/<name>";
  description = "<host>";
};
```

実ユーザーの作成/削除は OS レベルの操作なので注意してください。

