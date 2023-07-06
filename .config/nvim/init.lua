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
  "MunifTanjim/nui.nvim",
  "nvim-lua/plenary.nvim",
  "nvim-tree/nvim-web-devicons",
  "nvim-neo-tree/neo-tree.nvim",
    config = function()
      require("neo-tree").setup()
    end,
  "nvim-telescope/telescope.nvim", tag = '0.1.2',
  "nvim-treesitter/nvim-treesitter",
  {'neovim/nvim-lspconfig'},             -- Required
  {                                      -- Optional
    'williamboman/mason.nvim',
    build = function()
      pcall(vim.cmd, 'MasonUpdate')
    end,
  },
  'williamboman/mason-lspconfig.nvim',
  'neovim/nvim-lspconfig',
  {'hrsh7th/nvim-cmp'},     -- Required
  {'hrsh7th/cmp-nvim-lsp'}, -- Required
  {'L3MON4D3/LuaSnip'},     -- Required
  'VonHeikemen/lsp-zero.nvim', branch = 'v2.x'
}
require("lazy").setup(plugins)

local lsp = require('lsp-zero').preset({})

lsp.on_attach(function(client, bufnr)
  lsp.default_keymaps({buffer = bufnr})
end)

-- (Optional) Configure lua language server for neovim
require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

lsp.setup()

vim.keymap.set('n', '<F2>', '<cmd>Neotree toggle<cr>')
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<C-p>', builtin.find_files, {})
vim.keymap.set('i', 'jj', '<Esc>')
vim.keymap.set('t', 'jj', '<C-\\><C-n>')

vim.keymap.set('t', '<C-h>', '<C-\\><C-N><C-w>h')
vim.keymap.set('t', '<C-j>', '<C-\\><C-N><C-w>j')
vim.keymap.set('t', '<C-k>', '<C-\\><C-N><C-w>k')
vim.keymap.set('t', '<C-l>', '<C-\\><C-N><C-w>l')
vim.keymap.set('i', '<C-h>', '<C-\\><C-N><C-w>h')
vim.keymap.set('i', '<C-j>', '<C-\\><C-N><C-w>j')
vim.keymap.set('i', '<C-k>', '<C-\\><C-N><C-w>k')
vim.keymap.set('i', '<C-l>', '<C-\\><C-N><C-w>l')
vim.keymap.set('n', '<C-h>', '<C-w>h')
vim.keymap.set('n', '<C-j>', '<C-w>j')
vim.keymap.set('n', '<C-k>', '<C-w>k')
vim.keymap.set('n', '<C-l>', '<C-w>l')

vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
-- show line numbers
vim.opt.number = true
vim.opt.listchars="tab:▸▸,trail:-"
vim.opt.list = true
