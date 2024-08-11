-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  cmd = 'Neotree',
  keys = {
    { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal' },
    { '<A-\\>', ':Neotree close<CR>', desc = 'NeoTree close' },
  },
  opts = {
    filesystem = {
      use_libuv_file_watcher = true,
      follow_current_file = { enabled = true },
      window = {
        mappings = {
          ['\\'] = 'close_window',
          ['l'] = 'open',
          ['h'] = 'close_node',
          ['<space>'] = 'none',
        },
        default_component_configs = {
          indent = {
            with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
            expander_collapsed = '',
            expander_expanded = '',
            expander_highlight = 'NeoTreeExpander',
          },
          git_status = {
            symbols = {
              unstaged = '󰄱',
              staged = '󰱒',
            },
          },
        },
      },
    },
  },
}
