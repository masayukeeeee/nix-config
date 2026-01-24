{ pkgs, ... }: 
let
  # 1. エクスポートしたJSONを読み込む
  profileData = builtins.fromJSON (builtins.readFile ./profile.json);

  # ▼▼▼ ここでサイズを指定してください ▼▼▼
  fontSize = 21;

  # 2. 上書きしたい設定（フォント設定 + シェル設定）
  nixOverrides = {
    "Name" = "Nix Managed";
    
    # フォント設定 (名前 + サイズ の文字列を作成)s
    "Normal Font" = "MesloLGS-NF-Regular ${toString fontSize}";
    "Non Ascii Font" = "Monaco ${toString fontSize}";

    # シェル設定 (NixのZshを使う設定)
    "Custom Command" = "Yes";
    "Command" = "${pkgs.zsh}/bin/zsh -l";
  };
  
  # 3. マージ（元の設定 // 上書き設定）
  finalProfile = profileData // nixOverrides;
in
{
  # Dynamic Profiles としてファイルを生成
  home.file."Library/Application Support/iTerm2/DynamicProfiles/nix-managed.json".text = builtins.toJSON {
    "Profiles" = [ finalProfile ];
  };
}
s