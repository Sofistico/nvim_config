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
    filetypes = { 'cpp', 'c' },
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
      diagnostic_signs[vim.diagnostic.severity[type]] = icon
    end
    vim.diagnostic.config {
      signs = { text = diagnostic_signs, priority = 20 },
      float = { source = 'if_many' },
      virtual_text = { source = 'if_many', severity = { min = vim.diagnostic.severity.INFO } },
    }
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

  capabilities = vim.tbl_deep_extend('force', capabilities, global_capabilities)

  if init_helper.is_loaded 'cmp_nvim_lsp' then
    capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
  elseif init_helper.is_loaded 'blink.cmp' then
    capabilities = vim.tbl_deep_extend('force', capabilities, require('blink.cmp').get_lsp_capabilities(capabilities))
  end
  lsp_server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, lsp_server.capabilities or {})
end

---@class LineRange
---@field line integer
---@field character integer

---@class EditRange
---@field start LineRange
---@field end LineRange

---@class TextEdit
---@field newText string
---@field range EditRange

---@param edit TextEdit
function M.apply_vs_text_edit(edit)
  local bufnr = vim.api.nvim_get_current_buf()
  local start_line = edit.range.start.line
  local start_char = edit.range.start.character
  local end_line = edit.range['end'].line
  local end_char = edit.range['end'].character

  local newText = string.gsub(edit.newText, '\r', '')
  local lines = vim.split(newText, '\n')

  local placeholder_row = -1
  local placeholder_col = -1

  -- placeholder handling
  for i, line in ipairs(lines) do
    local pos = string.find(line, '%$0')
    if pos then
      lines[i] = string.gsub(line, '%$0', '', 1)
      placeholder_row = start_line + i - 1
      placeholder_col = pos - 1
      break
    end
  end

  vim.api.nvim_buf_set_text(bufnr, start_line, start_char, end_line, end_char, lines)

  if placeholder_row ~= -1 and placeholder_col ~= -1 then
    local win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_cursor(win, { placeholder_row + 1, placeholder_col })
  end
end

return M
