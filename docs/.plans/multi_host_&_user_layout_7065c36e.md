---
name: Multi host & user layout
overview: hosts/ と users/ に分離し、darwinConfigurationsに 2023-X0160 を追加、home-manager.usersに msakai を追加して、端末/ユーザーごとに切り替え可能にします。
todos:
  - id: create-layout
    content: hosts/<host>/ と users/<user>/ を新設し、既存darwin/home設定を適切に移動・分割する
    status: pending
  - id: update-flake-outputs
    content: flake.nix の darwinConfigurations を hosts/<host>/default.nix ベースに組み替え、2023-X0160 を追加する
    status: pending
    dependencies:
      - create-layout
  - id: add-msakai-user
    content: users/msakai/home.nix を追加し、home-manager.users.msakai をホスト側で配線する
    status: pending
    dependencies:
      - create-layout
      - update-flake-outputs
  - id: keep-existing
    content: 既存 MasayukiSakainoMacBook-Air / masayukisakai も同構成に移行して動作維持する
    status: pending
    dependencies:
      - create-layout
      - update-flake-outputs
---

# 複数ホスト/複数ユーザー対応のディレクトリ構成へ移行

## ゴール

- `darwinConfigurations` に **既存 `MasayukiSakainoMacBook-Air` を維持**しつつ、**新規 `2023-X0160` を追加**する。
- home-manager に **既存 `masayukisakai` を維持**しつつ、**新規ユーザー `msakai` を追加**する。
- 設定の置き場所を `hosts/` と `users/` に分離し、端末（ホスト）とユーザーの組み合わせで管理しやすくする。

## 推奨ディレクトリ構成

- `hosts/<host>/darwin.nix`: ホスト固有（macOS設定、homebrew、servicesなど）
- `hosts/<host>/default.nix`: そのホストで有効にするユーザーや追加モジュールの配線
- `users/<user>/home.nix`: ユーザー固有（home-manager設定の「差分」だけ）
- `home/`: home-manager向けの共通モジュール群
- `home/common/default.nix`: 共通の `imports` ハブ
- `home/common/packages.nix`: 共通CLIツール
- `home/common/git.nix`: Git共通設定（ユーザー名/メールはユーザー側で上書き）
- `home/common/zsh.nix`: zsh共通設定（alias等の差分はユーザー側で上書き）
- `home/apps/*`: 既存の `modules/apps/*` をここへ寄せるか、現状維持でもOK（後述）
- `modules/`: 端末・ユーザーを跨いで共通化したい nix-darwin / その他モジュール（home以外）

例:

- `hosts/MasayukiSakainoMacBook-Air/`
- `hosts/2023-X0160/`
- `users/masayukisakai/`
- `users/msakai/`

## 実装方針（flake の組み立て）

- [` `````/Users/msakai/.config/nix-config/flake.nix````` `](/Users/msakai/.config/nix-config/flake.nix) の `darwinConfigurations` を、ホストごとに `./hosts/<host>/default.nix` を読む形に変更
- `home-manager.users.<user> = import ./users/<user>/home.nix;` をホスト側の `default.nix` で列挙（そのホストで使うユーザーだけを有効化）

## 既存ファイルの移動/分割（概要）

- [` `````/Users/msakai/.config/nix-config/modules/darwin.nix````` `](/Users/msakai/.config/nix-config/modules/darwin.nix) の内容を、主に `hosts/MasayukiSakainoMacBook-Air/darwin.nix` へ移動
- `system.primaryUser` や `users.users.<name>` はホスト/ユーザーに依存するのでホスト側へ
- [` `````/Users/msakai/.config/nix-config/modules/home.nix````` `](/Users/msakai/.config/nix-config/modules/home.nix) の内容は分割する
- 共通部分 → `home/common/*`（packages/zsh/git など）
- ユーザー差分 → `users/<user>/home.nix`（ユーザー名/メール、homeディレクトリ、端末固有aliasなど）
- 既存の `modules/apps/*` は以下どちらか（好みで選択）:
- **現状維持**: `modules/apps/*` を `home/common/default.nix` から `imports` する
- **整理**: `home/apps/*` に移して、home-manager用の共通モジュールとして一箇所にまとめる

## Makefile の合わせ込み

- [` `````/Users/msakai/.config/nix-config/Makefile````` `](/Users/msakai/.config/nix-config/Makefile) の `DARWIN_HOST` は現状どおり「自動推測＋上書き」運用でOK
- `make show-config` / `make configure` を使うと、clone先でも `DARWIN_HOST=2023-X0160` などを固定できる

## 実行イメージ

- `make apply`（自動推測が当たる場合）
- `make apply DARWIN_HOST=2023-X0160`
- 永続化: `make configure DARWIN_HOST=2023-X0160`

## 受け入れ基準

- `darwin-rebuild switch --flake .#MasayukiSakainoMacBook-Air` と `...#2023-X0160` の両方が動く
- home-manager が `masayukisakai` と `msakai` の両方を定義できる（ホスト側で有効化ユーザーを選べる）

