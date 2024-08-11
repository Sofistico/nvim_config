return {
  'stevearc/oil.nvim',
  lazy = true,
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  cmd = 'TryOil',
  opts = {
    delete_to_trash = true,
  },
  keys = {
    { '-', '<cmd>Oil<cr>', desc = 'Open parent directory' },
  },
}
