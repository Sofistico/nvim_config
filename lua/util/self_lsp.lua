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

return M
