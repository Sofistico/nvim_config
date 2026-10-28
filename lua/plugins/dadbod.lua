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
        '<leader>cd',
        '<cmd>DBUIToggle<cr>',
        desc = 'Dadbod ui',
      },
    },
    init = function()
      -- Your DBUI configuration
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_execute_on_save = 0
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
