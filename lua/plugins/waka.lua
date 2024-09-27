return {
  'wakatime/vim-wakatime',
  event = 'BufAdd',
  keys = {
    { '<leader>xW', '<cmd>WakaTimeToday<cr>', desc = 'Show Waka Time Today' },
  },
  {
    'YannickFricke/codestats.nvim',
    event = 'BufAdd',
    opts = {
      token = 'SFMyNTY.VTI5bWFYTjBhV052IyNNak0wTVRJPQ.7mRxe7mM6HjODVimnP9cEB8XSAiPBm8JjwXrXIBDAJU',
    },
  },
}
