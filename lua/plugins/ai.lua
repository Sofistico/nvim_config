local copilot_enabled = false -- copilot always starts disabled

return {
  {
    'github/copilot.vim',
    config = function()
      vim.cmd 'Copilot disable'
    end,
    keys = {
      {
        '<leader>tC',
        function()
          if copilot_enabled then
            copilot_enabled = false
            vim.cmd 'Copilot disable'
            vim.notify 'Copilot disabled'
          else
            copilot_enabled = true
            vim.cmd 'Copilot enable'
            vim.notify 'Copilot enabled'
          end
        end,
        desc = 'Toggle copilot',
      },
    },
  },
  {
    'olimorris/codecompanion.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      'github/copilot.vim',
    },
    config = true,
    opts = {
      strategies = {
        chat = {
          adapter = 'copilot',
        },
        inline = {
          adapter = 'copilot',
        },
        cmd = {
          adapter = 'copilot',
        },
      },
    },
    keys = {
      {
        '<leader>aa',
        vim.cmd.CodeCompanionActions,
        desc = 'Code Companion Actions',
      },
      {
        '<leader>ai',
        vim.cmd.CodeCompanion,
        desc = 'Code Companion Inline',
      },
      {
        '<leader>aC',
        function()
          require('codecompanion').last_chat()
        end,
        desc = 'Code Companion Last Chat',
      },
      {
        '<leader>ac',
        function()
          require('codecompanion').chat()
        end,
        desc = 'Code Companion Chat',
      },
    },
  },
}
