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
