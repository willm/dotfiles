vim.loader.enable()
-- setup lazy.nvim package manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)
local plugins = {
  {
    "rebelot/kanagawa.nvim",
    --priority = 1000,
    config = function()
      require("kanagawa").setup({
        theme = "wave",
        background = {
          dark = "dragon",
        },
        colors = {
          theme = {
            all = { ui = { bg = "none", bg_gutter = "none" } },
          },
        },
      })
      vim.cmd.colorscheme("kanagawa")
    end,
  },
  { "dcampos/nvim-snippy" },
  { "dcampos/cmp-snippy" },
  { "mhartington/formatter.nvim" },
  { "nvim-lua/plenary.nvim" },
  { "nvim-pack/nvim-spectre" },
  { "MichaHoffmann/tree-sitter-hcl" },
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end,
  },
  { "hrsh7th/nvim-cmp" },
  require("plugins.neo-tree"),
  require("plugins.telescope"),
  {
    "nvim-treesitter/nvim-treesitter",
    config = function()
      local configs = require("nvim-treesitter.configs")
      configs.setup({
        ensure_installed = {
          "hcl",
          "typescript",
          "python",
          "rust",
          "groovy",
        },
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "hrsh7th/cmp-nvim-lsp" }, -- Required
      { "williamboman/mason-lspconfig.nvim" },
    },
  }, -- Required
  { -- Optional
    "williamboman/mason.nvim",
    build = function()
      pcall(vim.cmd, "MasonUpdate")
    end,
  },
  { "chrisbra/Colorizer" },
  { "MaxMEllon/vim-jsx-pretty" },
}
require("lazy").setup(plugins)

require("features.lsp")
require("formatting")
require("remaps")
require("features.sudo")
require("options")
require("features.terminal")
require("features.marp")
vim.api.nvim_create_autocmd(
  { "BufRead", "BufNewFile" },
  { pattern = "*.tf", command = "set filetype=hcl" }
)

vim.api.nvim_create_autocmd(
  { "BufRead", "BufNewFile" },
  { pattern = "Jenkinsfile", command = "set filetype=groovy" }
)
