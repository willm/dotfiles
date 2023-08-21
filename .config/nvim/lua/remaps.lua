vim.keymap.set("n", "<F2>", "<cmd>Neotree toggle<cr>")

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<C-p>", builtin.find_files, {})
vim.keymap.set("n", "<C-f>", builtin.grep_string, {})

vim.keymap.set("i", "jj", "<Esc>")
vim.keymap.set("t", "jj", "<C-\\><C-n>")

vim.keymap.set("t", "<C-h>", "<C-\\><C-N><C-w>h")
vim.keymap.set("t", "<C-j>", "<C-\\><C-N><C-w>j")
vim.keymap.set("t", "<C-k>", "<C-\\><C-N><C-w>k")
vim.keymap.set("t", "<C-l>", "<C-\\><C-N><C-w>l")
vim.keymap.set("i", "<C-h>", "<C-\\><C-N><C-w>h")
vim.keymap.set("i", "<C-j>", "<C-\\><C-N><C-w>j")
vim.keymap.set("i", "<C-k>", "<C-\\><C-N><C-w>k")
vim.keymap.set("i", "<C-l>", "<C-\\><C-N><C-w>l")
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

vim.keymap.set("n", "Y", "yy")

vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {})

local cmp = require("cmp")
local cmp_action = require("lsp-zero").cmp_action()
local snippy = require("snippy")
local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0
    and vim.api
        .nvim_buf_get_lines(0, line - 1, line, true)[1]
        :sub(col, col)
        :match("%s")
      == nil
end

cmp.setup({
  snippet = {
    expand = function(args)
      print("exanding")
      snippy.expand_snippet(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif snippy.can_expand_or_advance() then
        snippy.expand_or_advance()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "s" }),

    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif snippy.can_jump(-1) then
        snippy.previous()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "snippy" },
  }, {
    { name = "buffer" },
  }),
})
