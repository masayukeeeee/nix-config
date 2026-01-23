# nix-config

macOS 環境を **nix-darwin** + **home-manager**（flake）で管理するための個人設定リポジトリです。

- English README: [`README.md`](README.md)
- Docs (JP):
  - リポジトリ構成: [`docs/jp/structure.md`](docs/jp/structure.md)
  - ユーザー追加/削除: [`docs/jp/user-management.md`](docs/jp/user-management.md)
  - make コマンド: [`docs/jp/commands.md`](docs/jp/commands.md)

## 概要

- **ホスト**は `hosts/<host>/` にあり、`flake.nix` の `darwinConfigurations.<host>` として公開されています。
- **ユーザー**は `users/<user>/home.nix` に定義し、各ホストの `hosts/<host>/default.nix` で `home-manager.users.<user> = import ...;` を列挙して有効化します。
- 推奨フローはルート `Makefile` を使い、端末固有の設定は `Makefile.local` に分離します（git 管理外）。

## 最短手順（install -> apply）

1. Nix をインストール（Determinate Nix Installer）:

```bash
make install
```

2. `nix` が PATH に入っていない場合は、新しいシェルを開くか `make install` が案内するスクリプトを source してください。

3. `Makefile.local` を生成（`DARWIN_HOST` に現在のホスト名を設定）:

```bash
make configure
```

4. 状態確認:

```bash
make status
```

5. 設定の反映:

```bash
make apply
```

## ユーザーの追加/削除

詳細: [`docs/jp/user-management.md`](docs/jp/user-management.md)

## uninstall（Nix のアンインストール）

Determinate 経由でインストールされた Nix をアンインストールします:

```bash
make uninstall
```

注意:
- `sudo` が必要になることがあります。
- `/nix/nix-installer` が見つからない場合はエラーになります（Determinate 以外で入っている可能性）。

