return {
  "nvim-treesitter/nvim-treesitter",
  branch = "master",
  build = ":TSUpdate",
  event = { "BufReadPre", "BufNewFile" }, -- 読み込みタイミングを明示してエラーを防ぐ
  main = "nvim-treesitter.configs",       -- 実行するメインモジュールを指定
  opts = {                                -- setup() に渡す引数を opts で定義
    ensure_installed = {
      "bash",
      "css",
      "html",
      "javascript",
      "json",
      "lua",
      "python",
      "typescript",
      "yaml",
      "toml",
      "c",
      "cpp",
      "rust",
      "go",
      "java",
      "r",
      "sql",
      "sqlx",
      "markdown"
    },
    sync_install = false,
    highlight = { enable = true },
    indent = { enable = true },
  },
}