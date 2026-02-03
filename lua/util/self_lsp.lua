local init_helper = require 'util.self_init'

--@class self_lsp
local M = {
  ensure_lsps_not_in_mason = {
    'nushell',
  },
  ensure_installed_lsp = { 'lua_ls' },
  -- Enable the following language servers
  --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
  --
  --  Add any additional override configuration in the following tables. Available keys are:
  --  - cmd (table): Override the default command used to start the server
  --  - filetypes (table): Override the default list of associated filetypes for the server
  --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
  --  - settings (table): Override the default settings passed when initializing the server.
  --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
  servers = {
    -- clangd = {},
    -- gopls = {},
    -- pyright = {},
    -- rust_analyzer = {},
    -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
    --
    -- Some languages (like typescript) have entire language plugins that can be useful:
    --    https://github.com/pmizio/typescript-tools.nvim
    --
    -- But for many setups, the LSP (`tsserver`) will work just fine
    -- tsserver = {},
    --
    lua_ls = {
      -- cmd = {...},
      -- filetypes = { ...},
      -- capabilities = {},
      settings = {
        Lua = {
          completion = {
            callSnippet = 'Replace',
          },
          -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
          -- diagnostics = { disable = { 'missing-fields' } },
          hint = { enable = true },
        },
      },
    },
    clangd = {
      root_dir = function(fname)
        return require('lspconfig.util').root_pattern(
          'Makefile',
          'configure.ac',
          'configure.in',
          'config.h.in',
          'meson.build',
          'meson_options.txt',
          'build.ninja'
        )(fname) or require('lspconfig.util').root_pattern('compile_commands.json', 'compile_flags.txt')(fname) or vim.fs.dirname(
          vim.fs.find('.git', { path = fname, upward = true })[1]
        )
      end,
      capabilities = {
        offsetEncoding = { 'utf-16' },
      },
      cmd = {
        'clangd',
        '--background-index',
        '--clang-tidy',
        '--header-insertion=iwyu',
        '--completion-style=detailed',
        '--function-arg-placeholders',
        '--fallback-style=llvm',
      },
      init_options = {
        usePlaceholders = true,
        completeUnimported = true,
        clangdFileStatus = true,
      },
    },
    html = {
      filetypes = { 'html', 'templ', 'razor' },
    },
    nushell = {},
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

function M.enable_lsps_not_in_mason()
  for _, server_name in ipairs(M.ensure_lsps_not_in_mason) do
    vim.lsp.config(server_name, M.servers[server_name] or {})
  end
end

return M
