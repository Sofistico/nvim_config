return {
  {
    'kristijanhusak/vim-dadbod-ui',
    lazy = true,
    dependencies = { 'tpope/vim-dadbod' },
    cmd = {
      'DBUI',
      'DBUIToggle',
      'DBUIAddConnection',
      'DBUIFindBuffer',
    },
    keys = {
      {
        '<leader>td',
        '<cmd>DBUIToggle<cr>',
        desc = 'Toggle dadbod ui',
      },
    },
    init = function()
      -- Your DBUI configuration
      vim.g.db_ui_use_nerd_fonts = 1
    end,
  },
  {
    'tpope/vim-dadbod',
    dependencies = {
      'kristijanhusak/vim-dadbod-completion',
      'kristijanhusak/vim-dadbod-ui',
    },
    lazy = true,
    ft = 'sql',
    cmd = 'DB',
  },
}
