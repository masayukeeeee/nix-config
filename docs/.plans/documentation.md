# Documentation Plans

このディレクトリ（`docs/.plans/`）は、利用者向けドキュメント（`docs/jp`, `docs/en`）とは分離した **設計メモ / 実装プラン** の保管場所です。

---

## 2026-01-23: Docs expansion JP/EN

### Overview

- README（英語）と README_JP（日本語）、および `docs/jp`・`docs/en` に **構成 / ユーザー管理 / コマンド説明** を追加し、`install -> apply -> uninstall` の運用導線を明確化する。
- plan/設計メモは `docs/.plans/` に集約する（旧パスは残さない）。

### Files to add/update

- `README.md`（新規・英語）
- `README_JP.md`（新規・日本語）
- `docs/jp/structure.md`（新規）
- `docs/en/structure.md`（新規）
- `docs/jp/user-management.md`（新規）
- `docs/en/user-management.md`（新規）
- `docs/jp/commands.md`（新規）
- `docs/en/commands.md`（新規）

### Plan/設計メモの配置変更（docs/.plans）

- 目的: 利用者向けドキュメント（`docs/jp`, `docs/en`）と、設計メモ/plan（`.plans`）を分離して見通しを良くする
- 対象: 既存の plan ドキュメントを `docs/.plans/` に **完全移動** し、旧パスのファイルは残さない
  - `docs/makefile/plans.md` → `docs/.plans/makefile-implementation-plans.md`
  - `docs/split-users/multi_host_&_user_layout_7065c36e.plan.md` → `docs/.plans/multi_host_&_user_layout_7065c36e.plan.md`

### README 内容（英語/日本語）

- **概要**: この flake が提供するもの（nix-darwin + home-manager、設定は `hosts/` と `users/` に分離）を短く説明
- **install -> apply の最短導線**: 既存 `Makefile` の安全フローに合わせて記載
  - `make install`（Determinate Nix Installer）
  - `make configure`（`Makefile.local` 生成。`.gitignore` によりコミットされない）
  - `make status`（適用前チェック）
  - `make apply`（`darwin-rebuild switch --flake <dir>#<host>`）
- **ユーザー追加/削除**: README には手順の詳細を書かず、`docs/*/user-management.md` へリンク
- **uninstall**: `make uninstall`（Determinate 由来の `/nix/nix-installer uninstall`）と注意事項

### docs 内容（JP/ENで同一構成）

- **structure.md**
  - 主要ディレクトリの役割: `flake.nix`, `hosts/`, `users/`, `home/common/`, `modules/`, `files/config/`, `docs/`
  - 「ホスト=darwinConfigurations」「ユーザー=home-manager.users」の対応関係
- **user-management.md**
  - ユーザー追加:
    - `users/<newUser>/home.nix` を作る（`home.username` / `home.homeDirectory` / 必要な上書き）
    - 対象ホストの `hosts/<host>/default.nix` に `home-manager.users.<newUser> = import ...;` を追加
    - `make status` → `make apply`
  - ユーザー削除:
    - `hosts/<host>/default.nix` から該当 `home-manager.users.<user>` を外す
    - 必要なら `users/<user>/home.nix` を削除
    - `make apply`
  - 注意点: macOS の実ユーザー作成/削除（`users.users.<name>`）は別物（必要なら `hosts/<host>/darwin.nix` 側）
- **commands.md**
  - `Makefile` の各ターゲット説明: `install`, `uninstall`, `configure`, `status`, `status-body`, `apply`, `show-config`, `cleanup-safety`, `cleanup-all`
  - 重要な変数/挙動: `FLAKE_DIR`, `DARWIN_HOST`, `REQUIRE_LOCAL`, `USE_PAGER`, `NIX_FLAKE`
  - よくあるエラーと対処（例: `DARWIN_HOST is empty`, host module missing, nix not in PATH）

