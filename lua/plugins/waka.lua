return {
  {
    'wakatime/vim-wakatime',
    event = 'BufAdd',
    -- enabled = false,
    lazy = true,
    keys = {
      { '<leader>nw', '<cmd>WakaTimeToday<cr>', desc = 'Show Waka Time Today' },
    },
  },
  -- I Still don't know if i will keep this...
  -- Seems to slow down too much my typing, though i dunno if the root cause is this or the roslyn lsp
  -- Probably the damn lsp
  {
    'YannickFricke/codestats.nvim',
    event = 'BufAdd',
    --enabled = true,
    lazy = true,
    opts = {
      token = 'SFMyNTY.VTI5bWFYTjBhV052IyNNak0wTVRJPQ.7mRxe7mM6HjODVimnP9cEB8XSAiPBm8JjwXrXIBDAJU',
    },
  },
}
