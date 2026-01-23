---
name: Determinate Make targets
overview: Determinate Nix Installer 経由の install/uninstall/status と、このflakeの apply、さらに cleanup を safety/all に分けた Makefile を追加します。
todos:
  - id: add-makefile
    content: ルートにMakefileを新規作成し、install/uninstall/status/apply/cleanup-safety/cleanup-all/help/check-toolsを実装する
    status: pending
  - id: wire-darwin-apply
    content: applyターゲットで `darwin-rebuild switch --flake /Users/msakai/.config/nix-config#MasayukiSakainoMacBook-Air` を実行するよう設定する
    status: pending
    dependencies:
      - add-makefile
  - id: safe-vs-all-cleanup
    content: cleanup-safety（世代維持）とcleanup-all（-d相当）を明確に分け、危険側は警告を強めにする
    status: pending
    dependencies:
      - add-makefile
---

# Determinate Nix 用 Makefile 整備

## ゴール
- `make install` / `make uninstall` / `make status` / `make apply` / `make cleanup-safety` / `make cleanup-all` を用意し、**Determinate経由のNix管理**と**flake適用**を迷わず実行できるようにする。

## 現状把握（このリポジトリ）
- `flake.nix` は `darwinConfigurations."MasayukiSakainoMacBook-Air"` を定義しているため、`apply` は `--flake /Users/msakai/.config/nix-config#MasayukiSakainoMacBook-Air` で固定できる。
- `modules/darwin.nix` に `nix.enable = false;` があるため、Nix自体のインストール/管理は `nix-darwin` ではなく **Determinate** に寄せる方針と整合する。

## 追加/変更するファイル
- `[ /Users/msakai/.config/nix-config/Makefile ](/Users/msakai/.config/nix-config/Makefile)` を新規追加
  - 主要ターゲット: `install`, `uninstall`, `status`, `apply`, `cleanup-safety`, `cleanup-all`
  - 付随ターゲット: `help`（使い方一覧）、`check-tools`（必須コマンドの存在確認）

## ターゲット仕様（予定）
- **install**
  - `https://install.determinate.systems/nix` を `curl | sh` で実行（Determinateのインストーラ）
  - 既に `/nix/nix-installer` が存在する場合は、二重インストール防止のため警告して終了（必要なら手動でuninstallを促す）
- **uninstall**
  - `/nix/nix-installer uninstall` が存在すればそれを実行（なければ「Determinateで入っていない可能性」を表示）
  - 破壊的操作なので、実行前に強い警告を表示（sudoが必要な場合に備える）
- **status**
  - `command -v nix` / `nix --version`
  - `/nix/nix-installer` の有無
  - macOSの `nix-daemon` サービス状況（`launchctl` ベースで軽く確認。失敗しても非致命）
  - flakeの対象ホスト名（`MasayukiSakainoMacBook-Air`）を表示して、`apply` の実体が分かるようにする
- **apply**
  - `sudo darwin-rebuild switch --flake /Users/msakai/.config/nix-config#MasayukiSakainoMacBook-Air`
  - 既存の `home.nix` の alias と齟齬が出ないよう、必要なら最後に `exec zsh` 相当の案内（実行は好みが分かれるので、まずはメッセージ表示に留める）
- **cleanup-safety**
  - 安全寄り: `nix store gc`（到達不能なパスのGC）と `nix-store --optimise`（あれば）など、**世代を削除しない**範囲
- **cleanup-all**
  - 強め: `nix-collect-garbage -d`（古い世代を削除）まで含める（必要に応じて `sudo`）

## 実装上の注意
- `make -f` は Makefile指定の標準オプションなので、強制フラグとしては使わず、今回のように **ターゲット名で安全/強めを分離**する。
- Determinateの挙動差（`/nix/nix-installer` の有無等）に備え、Makefile内で存在チェックして分かりやすいエラーメッセージを出す。

## 受け入れ基準
- `make help` で全ターゲットと説明が見える
- 破壊的操作（`uninstall`, `cleanup-all`）は実行前に警告が出る
- `apply` が `#MasayukiSakainoMacBook-Air` に対して動く

