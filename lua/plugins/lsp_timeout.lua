return {
  'hinell/lsp-timeout.nvim',
  dependencies = { 'neovim/nvim-lspconfig' },
  lazy = true,
  init = function()
    vim.g.lspTimeoutConfig = {
      -- see config below
      stopTimeout = 1000 * 60 * 5, -- ms, timeout before stopping all LSPs
      startTimeout = 1000 * 10, -- ms, timeout before restart
      silent = false, -- true to suppress notifications
      filetypes = {
        ignore = { -- filetypes to ignore; empty by default
          -- lsp-timeout is disabled completely
        }, -- for these filetypes
      },
    }
  end,
}
