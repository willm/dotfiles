-- terminal helpers

-- switch to insert mode when navigating to a terminal buffer
vim.api.nvim_create_autocmd(
  { "TermOpen", "WinEnter" },
  { pattern = "term://*", command = "startinsert" }
)

-- open a terminal in a vertical split more easily
vim.api.nvim_create_user_command("TermOpenVsplit", function()
  vim.cmd("vs | term")
end, {})

vim.keymap.set("n", "<leader>T", "<cmd>TermOpenVsplit<cr>")

-- open a terminal in a horizontal split more easily
vim.api.nvim_create_user_command("TermOpenHsplit", function()
  vim.cmd("sp | term")
end, {})

vim.keymap.set("n", "<leader>t", "<cmd>TermOpenHsplit<cr>")
