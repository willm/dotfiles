require("mason").setup()
vim.lsp.enable({
  "ts_ls",
  "lua_ls",
  "groovyls",
  "pyright",
  "bashls",
  "terraformls",
  "rust_analyzer",
})
vim.lsp.config("groovyls", {
  cmd = {
    "java",
    "-jar",
    "/home/will/code/me/groovy-language-server/build/libs/groovy-language-server-all.jar",
  },
  -- Run single-file only: never send a rootUri. On initialize the server walks
  -- the whole workspace for *.groovy (CompilationUnitFactory.create), and its
  -- `catch (IOException)` cannot catch the UncheckedIOException that Files.walk
  -- throws on an unreadable directory, so any root-owned dir in the tree (e.g. a
  -- mysql container volume) kills the server with an InternalError. With no
  -- rootUri, setWorkspaceRoot is skipped and only open files are compiled.
  -- Trade-off: no cross-file definitions or workspace symbols.
  --
  -- This has to happen in before_init rather than via root_dir: returning no
  -- root from root_dir just makes vim.lsp.start() fall back to `root_markers`
  -- (lsp.lua:745), which nvim-lspconfig sets to { 'Jenkinsfile', '.git' }.
  -- GroovyLanguageServer.initialize only ever reads rootUri, so clearing it is
  -- enough; rootPath and workspaceFolders are ignored by the server.
  before_init = function(params)
    params.rootUri = vim.NIL
    params.rootPath = vim.NIL
  end,
})
-- rust-analyzer reads everything under settings["rust-analyzer"]; options at the
-- top level are silently ignored.
vim.lsp.config("rust_analyzer", {
  settings = {
    ["rust-analyzer"] = {
      imports = {
        granularity = {
          group = "module",
        },
        prefix = "self",
      },
      cargo = {
        buildScripts = {
          enable = true,
        },
      },
      procMacro = {
        enable = true,
      },
    },
  },
})

vim.lsp.config("pyright", {
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "basic",
      },
    },
  },
})

-- Advertise nvim-cmp's completion capabilities to every server.
vim.lsp.config("*", {
  capabilities = require("cmp_nvim_lsp").default_capabilities(),
})

vim.api.nvim_create_autocmd("LspAttach", {
  desc = "LSP actions",
  callback = function(event)
    local opts = { buffer = event.buf }

    -- Replaces the old rust_analyzer-only on_attach, which clobbered the one
    -- nvim-lspconfig ships (it registers the :LspRustAnalyzer* commands).
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client:supports_method("textDocument/inlayHint") then
      vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
    end

    vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
    vim.keymap.set("n", ";", "<cmd>lua vim.diagnostic.open_float()<cr>", opts)
    vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
    vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
    vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
    vim.keymap.set(
      "n",
      "go",
      "<cmd>lua vim.lsp.buf.type_definition()<cr>",
      opts
    )
    vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
    vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
    vim.keymap.set("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
    vim.keymap.set(
      { "n", "x" },
      "<F3>",
      "<cmd>lua vim.lsp.buf.format({async = true})<cr>",
      opts
    )
    vim.keymap.set("n", "<F4>", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
  end,
})

local cmp = require("cmp")
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
