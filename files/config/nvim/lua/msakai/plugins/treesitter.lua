return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    local configs = require("nvim-treesitter.configs")

    configs.setup({
      enure_installed = {
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
    })
  end
}

