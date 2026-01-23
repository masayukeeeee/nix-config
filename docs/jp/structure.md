# リポジトリ構成

このリポジトリは **nix-darwin** + **home-manager** を flake として管理するための設定一式です。

## トップレベル

- `flake.nix`
  - `darwinConfigurations.<host>`（nix-darwin のエントリポイント）を定義します。
- `Makefile`
  - 安全な運用フロー（`install` -> `configure` -> `status` -> `apply`）とユーティリティを提供します。
- `Makefile.local`（生成される・git 管理外）
  - `DARWIN_HOST` や `FLAKE_DIR` など、端末固有の上書き設定を置きます。

## 主要ディレクトリ

- `hosts/<host>/`
  - `default.nix`: ホストのモジュール読み込みと、home-manager ユーザー有効化の配線
  - `darwin.nix`: ホスト固有の nix-darwin 設定（system defaults / services / Homebrew など）
- `users/<user>/home.nix`
  - ユーザー固有の home-manager 設定（ユーザー名/ホームディレクトリ、必要に応じた上書き）
- `home/common/`
  - 共通の home-manager モジュール群（imports ハブ、packages、zsh、git など）
- `modules/apps/`
  - アプリ別 home-manager モジュール（karabiner / yabai / skhd / nvim / fzf / zsh）
- `files/config/`
  - home-manager により `$XDG_CONFIG_HOME` 配下へリンクされる静的設定（例: Neovim）
- `docs/`
  - `docs/en`: 利用者向けドキュメント（英語）
  - `docs/jp`: 利用者向けドキュメント（日本語）
  - `docs/.plans`: 設計メモ / 実装プラン

## ホスト/ユーザーの配線（概念）

- 対象ホストは `darwin-rebuild switch --flake <flakeDir>#<host>` で選択します。
- 各ホストは `hosts/<host>/default.nix` で home-manager ユーザーを列挙して有効化します:
  - `home-manager.users.<user> = import ../../users/<user>/home.nix;`

関連:
- ユーザー管理: [`docs/jp/user-management.md`](user-management.md)
- make コマンド: [`docs/jp/commands.md`](commands.md)

