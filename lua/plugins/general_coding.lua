return -- snippets
{
  {
    'folke/ts-comments.nvim',
    opts = {},
    event = 'BufAdd',
    lazy = true,
  },
  -- {
  --   'folke/todo-comments.nvim',
  --   event = 'BufAdd',
  --   dependencies = { 'nvim-lua/plenary.nvim' },
  --   opts = { signs = false },
  --   keys = { { '<leader>st', '<cmd>TodoTelescope<cr>', desc = '[S]earch [T]odo' }, silent = true },
  -- },
  -- library used by other plugins
  { 'nvim-lua/plenary.nvim', lazy = true },
  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    event = 'BufAdd',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local harpoon = require 'harpoon'

      -- REQUIRED
      harpoon:setup()
      -- REQUIRED

      vim.keymap.set('n', '<leader>h', function()
        harpoon:list():add()
      end, { desc = 'Add to harpoon' })
      vim.keymap.set('n', '<C-\\>', function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end, { desc = 'Quick menu' })

      vim.keymap.set('n', '<C-x>', function()
        harpoon:list():select(1)
      end, { desc = 'Go to first harpoon' })
      vim.keymap.set('n', '<C-c>', function()
        harpoon:list():select(2)
      end, { desc = 'Go to second harpoon' })
      vim.keymap.set('n', '<C-n>', function()
        harpoon:list():select(3)
      end, { desc = 'Go to third harpoon' })
      vim.keymap.set('n', '<C-p>', function()
        harpoon:list():select(4)
      end, { desc = 'Go to fourth harpoon' })

      -- Toggle previous & next buffers stored within Harpoon list
      vim.keymap.set('n', '<leader>j', function()
        harpoon:list():prev()
      end, { desc = 'Previous buffer harpoon' })
      vim.keymap.set('n', '<leader>k', function()
        harpoon:list():next()
      end, { desc = 'Next buffer harpoon' })
    end,
  },
}
