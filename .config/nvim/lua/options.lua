vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
-- show line numbers
vim.opt.number = true
vim.opt.listchars = "tab:▸▸,trail:-"
vim.opt.list = true
vim.opt.ignorecase = true
vim.opt_local.spell = true
vim.opt.spelllang = "en,fr"
vim.opt.spelloptions = "camel"
-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.wrap = true
-- local config
vim.o.exrc = true
vim.o.secure = true
-- whitespace chars
vim.o.listchars = "tab:>·,trail:~,extends:>,precedes:<,space:."
