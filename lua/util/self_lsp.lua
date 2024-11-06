--@class self_lsp
local M = {
  omnisharp = {
    {
      --@field table|string
      key = 'gr',
      func = function()
        require('omnisharp_extended').telescope_lsp_references { layout_strategy = 'vertical', show_line = false }
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
}

return M
