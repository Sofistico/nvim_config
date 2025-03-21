--@class self_lsp
local M = {
  omnisharp = {
    keys = {
      {
        --@field table|string
        key = 'gr',
        func = function()
          require('omnisharp_extended').telescope_lsp_references { layout_strategy = 'vertical', show_line = false, path_display = { 'truncate' } }
        end,
        desc = '[G]oto [R]eferences',
        mode = 'n',
      },
      {
        key = { 'gd', '<F12>' },
        func = function()
          require('omnisharp_extended').telescope_lsp_definitions()
        end,
        desc = '[G]oto [D]efinition',
        mode = 'n',
      },
      {
        key = { 'gI', '<C-F12>' },
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
      { key = '<leader>ch', func = '<cmd>ClangdSwitchSourceHeader<cr>', desc = 'Switch Source/Header (C/C++)' },
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
        virtual_text = { severity = { min = vim.diagnostic.severity.INFO } },
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

  if vim.fn.has 'nvim-0.10.2' == 1 then
    -- monkey patch the request proxy
    client.request = function(method, params, handler, req_bufnr)
      if method ~= vim.lsp.protocol.Methods.textDocument_semanticTokens_full then
        return request_inner(method, params, handler)
      end

      local target_bufnr = vim.uri_to_bufnr(params.textDocument.uri)
      local line_count = vim.api.nvim_buf_line_count(target_bufnr)
      local last_line = vim.api.nvim_buf_get_lines(target_bufnr, line_count - 1, line_count, true)[1]

      return request_inner('textDocument/semanticTokens/range', {
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
  elseif vim.fn.has 'nvm-0.11' == 1 then
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
end

return M
