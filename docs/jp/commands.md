# make コマンド

このリポジトリはルートの `Makefile` で運用する前提です。

## よく使うフロー

```bash
make install
make configure
make status
make apply
```

## ターゲット一覧

- `make install`
  - Determinate Nix Installer（`curl | sh`）で Nix をインストールします。
- `make uninstall`
  - `/nix/nix-installer uninstall`（存在する場合）で Nix をアンインストールします。
- `make configure`
  - `Makefile.local`（git 管理外）を生成します:
    - `FLAKE_DIR := <このリポジトリ>`
    - `DARWIN_HOST := <現在のホスト名>`
- `make status`
  - 適用可能状態かどうかのチェックを見やすく表示します（`USE_PAGER=1` でページャ利用）。
- `make status-body`
  - `status` の実体（生の出力）。
- `make show-config`
  - `FLAKE_DIR`, `DARWIN_HOST` などの有効値と、上書き例を表示します。
- `make apply`
  - 安全チェック後に `sudo darwin-rebuild switch --flake $(FLAKE_DIR)#$(DARWIN_HOST)` を実行します。
- `make cleanup-safety`
  - `nix store gc` と `nix store optimise` を実行します（**世代削除なし**）。
- `make cleanup-all`
  - `nix-collect-garbage -d` と `nix store optimise` を実行します（強め）。

## 変数（上書き）

`Makefile.local` またはコマンドラインで上書きできます。

- `FLAKE_DIR`
  - デフォルトはリポジトリルート（`Makefile` のあるディレクトリ）。
  - `flake.nix` が存在する必要があります。
- `DARWIN_HOST`
  - 対象ホスト名（`hosts/<DARWIN_HOST>/default.nix` が存在し、flake の `darwinConfigurations` に含まれる必要があります）。
- `REQUIRE_LOCAL`
  - デフォルト `1`。有効な場合、`make apply` 前に `Makefile.local` を必須にします（安全運用）。
  - バイパス例: `make apply REQUIRE_LOCAL=0 DARWIN_HOST=<host>`
- `USE_PAGER`
  - デフォルト `0`。`1` のとき `make status` が `less -R` を使う場合があります。
- `NIX_FLAKE`
  - flake 評価に使う nix コマンド（デフォルト）:
    - `nix --extra-experimental-features nix-command --extra-experimental-features flakes`

## よくあるエラーと対処

- `ERROR: Makefile.local is required before apply`
  - `make configure` を実行
  - もしくは: `make apply REQUIRE_LOCAL=0 DARWIN_HOST=<host>`
- `ERROR: DARWIN_HOST is empty`
  - `make configure` を実行
  - もしくは: `make apply DARWIN_HOST=<host> REQUIRE_LOCAL=0`
- `ERROR: host module not found: hosts/<host>/default.nix`
  - 利用可能ホストを確認: `ls hosts/`
- `ERROR: nix not found in PATH`
  - 新しいシェルを開くか、`make install` が案内するスクリプトを source

