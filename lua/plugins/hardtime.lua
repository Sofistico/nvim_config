return {
  {
    'm4xshen/hardtime.nvim',
    dependencies = { 'MunifTanjim/nui.nvim' },
    lazy = true,
    -- event = 'BufAdd',
    opts = {
      restricted_keys = {
        ['-'] = {},
      },
    },
    keys = { { '<leader>tH', '<cmd>Hardtime toggle<cr>', desc = 'Toggle hardtime', silent = true } },
  },
}
