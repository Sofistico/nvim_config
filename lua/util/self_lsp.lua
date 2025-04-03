local init_helper = require 'util.self_init'

--@class self_lsp
local M = {
  omnisharp = {
    keys = {
      {
        --@field table|string
        key = 'gdr',
        func = function()
          require('omnisharp_extended').telescope_lsp_references { layout_strategy = 'vertical', show_line = false, path_display = { 'truncate' } }
        end,
        desc = '[G]oto [R]eferences',
        mode = 'n',
      },
      {
        key = { 'grd', '<F12>' },
        func = function()
          require('omnisharp_extended').telescope_lsp_definitions()
        end,
        desc = '[G]oto [D]efinition',
        mode = 'n',
      },
      {
        key = { 'gri', '<C-F12>' },
        func = function()
          require('omnisharp_extended').telescope_lsp_implementation()
        end,
        desc = '[G]oto [I]mplementation',
      },
    },
    debugger = 'netcoredbg',
  },
  clangd = {
    setup = {},
    keys = {
      { key = 'grh', func = '<cmd>ClangdSwitchSourceHeader<cr>', desc = 'Switch Source/Header (C/C++)' },
    },
  },
}

function M.config_lsp_diagnostic(has_nerd_font, icons, plugins)
  if has_nerd_font then
    local signs = {
      ERROR = icons.diagnostics.error_lsp,
      WARN = icons.diagnostics.warn_lsp,
      INFO = icons.diagnostics.info_lsp,
      HINT = icons.diagnostics.hint_lsp,
    }
    local diagnostic_signs = {}
    for type, icon in pairs(signs) do
      if vim.fn.has 'nvim-0.10.2' == 1 then
        diagnostic_signs[vim.diagnostic.severity[type]] = icon
      else
        local hl = 'DiagnosticSign' .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end
    end
    if vim.fn.has 'nvim-0.10.2' == 1 then
      vim.diagnostic.config {
        signs = { text = diagnostic_signs, priority = 20 },
        float = { source = 'if_many' },
        virtual_text = { source = 'if_many', severity = { min = vim.diagnostic.severity.INFO } },
      }
    end
    if plugins.is_loaded 'tiny-inline-diagnostic.nvim' then
      vim.diagnostic.config { virtual_text = false }
    end
  end
end

M.ensure_installed_lsp = { 'lua_ls' }

M.ensure_installed_tools = {
  'stylua', -- Used to format Lua code
  'csharpier', -- used to format c# code
  'netcoredbg', -- used to debug c#
  'markdownlint',
  'prettier',
}

M.ensure_installed_all = vim.tbl_extend('keep', M.ensure_installed_lsp, M.ensure_installed_tools)

-- this is for full semantic tokens in roslyn
function M.monkey_patch_semantic_tokens(client)
  -- NOTE: Super hacky... Don't know if I like that we set a random variable on
  -- the client Seems to work though
  if client.is_hacked then
    return
  end
  client.is_hacked = true

  -- let the runtime know the server can do semanticTokens/full now
  client.server_capabilities = vim.tbl_deep_extend('force', client.server_capabilities, {
    semanticTokensProvider = {
      full = true,
    },
  })
  local request_inner = client.request

  -- monkey patch the request proxy
  function client:request(method, params, handler, req_bufnr)
    if method ~= vim.lsp.protocol.Methods.textDocument_semanticTokens_full then
      return request_inner(self, method, params, handler)
    end

    local target_bufnr = vim.uri_to_bufnr(params.textDocument.uri)
    local line_count = vim.api.nvim_buf_line_count(target_bufnr)
    local last_line = vim.api.nvim_buf_get_lines(target_bufnr, line_count - 1, line_count, true)[1]

    return request_inner(self, 'textDocument/semanticTokens/range', {
      textDocument = params.textDocument,
      range = {
        ['start'] = {
          line = 0,
          character = 0,
        },
        ['end'] = {
          line = line_count - 1,
          character = string.len(last_line) - 1,
        },
      },
    }, handler, req_bufnr)
  end
end

-- add any global capabilities here
-- @class lsp.ClientCapabilities
local global_capabilities = {
  textDocument = {
    foldingRange = {
      dynamicRegistration = true,
      lineFoldingOnly = true,
    },
  },
  workspace = {
    fileOperations = {
      didRename = true,
      willRename = true,
    },
    didChangeWatchedFiles = {
      dynamicRegistration = true,
      relativePatternSupport = true,
    },
  },
}

function M.make_capabilities(lsp_server)
  -- LSP servers and clients are able to communicate to each other what features they support.
  --  By default, Neovim doesn't support everything that is in the LSP specification.
  --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
  --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
  local capabilities = vim.lsp.protocol.make_client_capabilities()

  capabilities = vim.tbl_deep_extend('keep', capabilities, global_capabilities)

  if init_helper.is_loaded 'cmp_nvim_lsp' then
    capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
  elseif init_helper.is_loaded 'blink.cmp' then
    capabilities = vim.tbl_deep_extend('force', capabilities, require('blink.cmp').get_lsp_capabilities(capabilities))
  end
  lsp_server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, lsp_server.capabilities or {})
end

return M
