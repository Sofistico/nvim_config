return {
  {
    'zbirenbaum/copilot.lua',
    lazy = true,
    cmd = 'Copilot',
    config = function()
      require('copilot').setup {}
    end,
  },
  {
    'olimorris/codecompanion.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      'zbirenbaum/copilot.lua',
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
        '<leader>ai',
        function()
          vim.cmd "'<,'>CodeCompanion"
        end,
        desc = 'Code Companion Inline',
        mode = 'v',
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
