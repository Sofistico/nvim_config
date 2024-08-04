return {
  {
    'nvimdev/dashboard-nvim',
    event = 'VimEnter',
    config = function()
      require('dashboard').setup {
        -- config
        theme = 'hyper',
        config = {
          week_header = {
            enable = true,
          },
          shortcut = {
            { desc = '󰊳 Update', group = '@property', action = 'Lazy update', key = 'u' },
            {
              icon = ' ',
              icon_hl = '@variable',
              desc = 'Files',
              group = 'Label',
              action = 'Telescope find_files',
              key = 'f',
            },
            -- {
            --   desc = ' Apps',
            --   group = 'DiagnosticHint',
            --   action = 'Telescope app',
            --   key = 'a',
            -- },
            {
              desc = ' config',
              group = 'Number',
              action = function()
                local fk_opts = {
                  cwd = vim.env.XDG_CONFIG_HOME,
                  results_title = 'Config',
                }
                require('telescope.builtin').find_files(fk_opts)
              end,
              key = 'd',
            },
            { desc = 'Quit', group = '@property', action = 'q', key = 'q' },
          },
          -- footer = function()
          --   local stats = require('lazy').stats()
          --   local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
          --   return { '⚡ Neovim loaded ' .. stats.loaded .. '/' .. stats.count .. ' plugins in ' .. ms .. 'ms' }
          -- end,
        },
      }
    end,
    dependencies = { { 'nvim-tree/nvim-web-devicons' } },
  },
}
