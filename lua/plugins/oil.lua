return {
  'stevearc/oil.nvim',
  lazy = true,
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = {
    delete_to_trash = true,
    skip_confirm_for_simple_edits = true,
    watch_for_changes = false,
    view_options = {
      show_hidden = true,
    },
    lsp_file_methods = {
      enabled = false,
      timeout_ms = 1,
      -- autosave_changes = true,
    },
    keymaps = {
      ['gw'] = {
        function()
          require('oil').save(nil, nil)
        end,
        desc = 'Save Oil Buffer',
      },
      ['<leader>sF'] = {
        function()
          require('telescope.builtin').find_files {
            cwd = require('oil').get_current_dir(),
          }
        end,
        mode = 'n',
        nowait = true,
        desc = 'Find files in the current oil directory',
      },
      ['<leader>sS'] = {
        function()
          require('telescope.builtin').live_grep {
            cwd = require('oil').get_current_dir(),
          }
        end,
        mode = 'n',
        nowait = true,
        desc = 'RipGrep files in the current oil directory',
      },
      ['<C-k>'] = 'actions.select',
      ['gS'] = 'actions.change_sort',
      ['<C-v>'] = { 'actions.select', opts = { vertical = true, close = true } },
      ['<C-s>'] = { 'actions.select', opts = { horizontal = true, close = true } },
      ['<C-t>'] = { 'actions.select', opts = { tab = true, close = true } },
      ['<leader>:'] = {
        'actions.open_cmdline',
        opts = {
          shorten_path = true,
          modify = ':h',
        },
        desc = 'Open the command line with the current directory as an argument',
      },
      ['gd'] = {
        function()
          require('oil').set_columns { 'icon', 'permissions', 'size', 'mtime' }
        end,
        mode = 'n',
        desc = 'Set detailed columns',
      },
    },
  },
  keys = {
    { '-', '<cmd>Oil<cr>', desc = 'Open parent directory' },
  },
  cmd = 'Oil',
}
