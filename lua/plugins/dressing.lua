return {
  'stevearc/dressing.nvim',
  lazy = true,
  event = 'BufAdd',
  opts = {
    input = {
      mappings = {
        i = {
          ['<C-k>'] = 'Confirm',
        },
      },
    },
  },
}
