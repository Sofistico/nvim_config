return {
  'stevearc/oil.nvim',
  lazy = true,
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  cmd = 'TryOil',
  opts = {
    delete_to_trash = true,
    default_file_explorer = true,
    skip_confirm_for_simple_edits = true,
    watch_for_changes = false,
    view_options = {
      show_hidden = true,
    }
  },
  keys = {
    { '-', '<cmd>Oil<cr>', desc = 'Open parent directory' },
  },
}
