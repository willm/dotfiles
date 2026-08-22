vim.loader.enable()
-- setup lazy.nvim package manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    lazyrepo,
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
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
  require("plugins.treesitter"),
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "hrsh7th/cmp-nvim-lsp" }, -- Required
      { "williamboman/mason-lspconfig.nvim" },
    },
  },
  {
    "mason-org/mason.nvim",
    opts = {},
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
require("ui")
