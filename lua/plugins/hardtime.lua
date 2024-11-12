return {
  {
    'm4xshen/hardtime.nvim',
    dependencies = { 'MunifTanjim/nui.nvim', 'nvim-lua/plenary.nvim' },
    lazy = true,
    -- event = 'BufAdd',
    opts = {},
    keys = { { '<leader>tH', '<cmd>Hardtime toggle<cr>', desc = 'Toggle hardtime', silent = true } },
  },
}
