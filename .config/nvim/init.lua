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
  "MunifTanjim/nui.nvim",
  "dcampos/nvim-snippy",
  "dcampos/cmp-snippy",
  "mhartington/formatter.nvim",
  "nvim-lua/plenary.nvim",
  "nvim-tree/nvim-web-devicons",
  "nvim-pack/nvim-spectre",
  require("plugins.neo-tree"),
  "MichaHoffmann/tree-sitter-hcl",
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
  require("plugins.telescope"),
  {
    "nvim-treesitter/nvim-treesitter",
    config = function()
      local configs = require("nvim-treesitter.configs")
      configs.setup({
        ensure_installed = {
          "hcl",
          "typescript",
        },
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
      })
    end,
  },
  { "neovim/nvim-lspconfig" }, -- Required
  { -- Optional
    "williamboman/mason.nvim",
    build = function()
      pcall(vim.cmd, "MasonUpdate")
    end,
  },
  "williamboman/mason-lspconfig.nvim",
  { "hrsh7th/nvim-cmp" }, -- Required
  { "hrsh7th/cmp-nvim-lsp" }, -- Required
  { "L3MON4D3/LuaSnip" }, -- Required
  { "simrat39/rust-tools.nvim" },
  "VonHeikemen/lsp-zero.nvim",
  branch = "v2.x",
  "chrisbra/Colorizer",
  "mfussenegger/nvim-dap",
  "rcarriga/nvim-dap-ui",
}
require("lazy").setup(plugins)

local lsp = require("lsp-zero").preset({})

lsp.on_attach(function(client, bufnr)
  client.server_capabilities.semanticTokensProvider = nil
  lsp.default_keymaps({ buffer = bufnr })
end)

-- (Optional) Configure lua language server for neovim
local lspconfig = require("lspconfig")
local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()
lspconfig.lua_ls.setup(lsp.nvim_lua_ls())
lspconfig.tsserver.setup({ capabilities = lsp_capabilities })
lspconfig.rust_analyzer.setup({
  -- Server-specific settings. See `:help lspconfig-setup`
  capabilities = { capabilities = lsp_capabilities },
  settings = {
    ["rust-analyzer"] = {},
  },
})

lsp.setup()

local rust_tools = require("rust-tools")
rust_tools.setup({
  server = {
    on_attach = function(_, bufnr)
      vim.keymap.set(
        "n",
        "<leader>ca",
        rust_tools.hover_actions.hover_actions,
        { buffer = bufnr }
      )
    end,
  },
})

require("formatting")
require("debugging")
require("remaps")
require("features.sudo")
require("options")
require("features.terminal")

vim.api.nvim_create_autocmd(
  { "BufRead", "BufNewFile" },
  { pattern = "*.tf", command = "set filetype=hcl" }
)
