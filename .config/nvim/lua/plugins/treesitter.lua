-- nvim-treesitter `main` branch: the `master` branch is locked to Nvim 0.11 and
-- its query directives (`#set-lang-from-info-string!`, `#downcase!`, ...) are
-- broken on 0.12, which is what blows up when opening markdown.
-- Requires the `tree-sitter-cli` package and a C compiler for :TSUpdate.
return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    local ts = require("nvim-treesitter")
    ts.setup()

    ts.install({
      "bash",
      "css",
      "dart",
      "diff",
      "dockerfile",
      "git_config",
      "gitcommit",
      "groovy",
      "hcl",
      "html",
      "javascript",
      "json",
      "lua",
      "luadoc",
      "markdown",
      "markdown_inline",
      "python",
      "query",
      "rust",
      "terraform",
      "toml",
      "tsx",
      "typescript",
      "vim",
      "vimdoc",
      "yaml",
    })

    -- main branch no longer has a `highlight` module; start the parser by hand.
    vim.api.nvim_create_autocmd("FileType", {
      desc = "Enable treesitter highlighting when a parser is available",
      callback = function(ev)
        local lang = vim.treesitter.language.get_lang(ev.match)
        if lang and vim.treesitter.language.add(lang) then
          vim.treesitter.start(ev.buf, lang)
        end
      end,
    })
  end,
}
