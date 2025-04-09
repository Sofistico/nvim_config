return {
  {
    'nvimdev/dashboard-nvim',
    event = 'VimEnter',
    config = function()
      require('dashboard').setup {
        -- config
        theme = 'hyper',
        shortcut_type = 'number',
        config = {
          week_header = {
            enable = true,
          },
          project = { enable = false },
          mru = { enable = true, cwd_only = true },
          shortcut = {
            { icon = '󰚰 ', icon_hl = '@variable', desc = 'Update', group = '@property', action = 'Lazy update', key = 'u' },
            {
              icon = ' ',
              icon_hl = '@variable',
              desc = 'Files',
              group = 'Label',
              action = 'Telescope find_files',
              key = 'f',
            },
            {
              icon = ' ',
              icon_hl = '@variable',
              desc = 'Session',
              group = 'Label',
              action = function()
                require('persistence').load()
              end,
              key = 'r',
            },
            {
              icon = ' ',
              icon_hl = '@variable',
              desc = 'Grep',
              group = 'Label',
              action = 'Telescope live_grep',
              key = 'g',
            },
            {
              icon = ' ',
              icon_hl = '@variable',
              desc = 'Config',
              group = 'Number',
              action = function()
                local fk_opts = {
                  cwd = vim.fn.stdpath 'config',
                  results_title = 'Config',
                }
                require('telescope.builtin').find_files(fk_opts)
              end,
              key = 'n',
            },
            {
              icon = '💤 ',
              desc = 'Lazy',
              group = 'Number',
              action = 'Lazy',
              key = 'l',
            },
            { icon = '󰿅 ', desc = 'Quit', group = '@property', action = 'q', key = 'q' },
          },
          footer = function()
            return { '🐶 woof: ' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':t') }
          end,
        },
      }
    end,
    dependencies = { { 'nvim-tree/nvim-web-devicons' }, 'folke/persistence.nvim' },
    keys = {
      { '<leader>h', '<cmd>Dashboard<cr>', desc = 'Go To Home' },
    },
  },
}
