local self_init = require 'util.self_init'
return {
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    main = 'nvim-treesitter.configs',
    branch = 'main',
    config = function()
      require('nvim-treesitter').setup()
      local filetypes =
        { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc', 'json', 'c_sharp', 'yaml', 'xml', 'json' }
      require('nvim-treesitter').install(filetypes)
      vim.api.nvim_create_autocmd('FileType', {
        pattern = filetypes,
        callback = function()
          vim.treesitter.start()
        end,
      })
    end,
  },
  -- Automatically add closing tags for HTML and JSX
  {
    'windwp/nvim-ts-autotag',
    ft = { 'html', 'xml' },
    lazy = true,
    opts = {},
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    event = 'BufAdd',
    lazy = true,
    opts = {
      mode = 'cursor',
      max_lines = 10,
    },
    keys = {
      {
        '[t',
        function()
          require('treesitter-context').go_to_context(vim.v.count1)
        end,
        desc = 'Go to context',
      },
      {
        '<leader>tc',
        function()
          require('treesitter-context').toggle()
        end,
        desc = 'Toggle treesitter context',
      },
    },
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    lazy = true,
    event = 'BufAdd',
    branch = 'main',
    init = function()
      -- Disable entire built-in ftplugin mappings to avoid conflicts.
      -- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
      -- vim.g.no_plugin_maps = true

      -- Or, disable per filetype (add as you like)
      -- vim.g.no_python_maps = true
      -- vim.g.no_ruby_maps = true
      -- vim.g.no_rust_maps = true
      -- vim.g.no_go_maps = true
    end,
    config = function()
      -- put your config here
      require('nvim-treesitter-textobjects').setup {
        select = {
          -- Automatically jump forward to textobj, similar to targets.vim
          lookahead = true,
          -- You can choose the select mode (default is charwise 'v')
          --
          -- Can also be a function which gets passed a table with the keys
          -- * query_string: eg '@function.inner'
          -- * method: eg 'v' or 'o'
          -- and should return the mode ('v', 'V', or '<c-v>') or a table
          -- mapping query_strings to modes.
          selection_modes = {
            ['@parameter.outer'] = 'v', -- charwise
            ['@function.outer'] = 'V', -- linewise
            -- ['@class.outer'] = '<c-v>', -- blockwise
          },
          -- If you set this to `true` (default is `false`) then any textobject is
          -- extended to include preceding or succeeding whitespace. Succeeding
          -- whitespace has priority in order to act similarly to eg the built-in
          -- `ap`.
          --
          -- Can also be a function which gets passed a table with the keys
          -- * query_string: eg '@function.inner'
          -- * selection_mode: eg 'v'
          -- and should return true of false
          include_surrounding_whitespace = false,
        },
      }
      vim.keymap.set({ 'n', 'x', 'o' }, ']m', function()
        require('nvim-treesitter-textobjects.move').goto_next_start('@function.outer', 'textobjects')
      end, { desc = 'Next function start' })
      vim.keymap.set({ 'n', 'x', 'o' }, ']]', function()
        require('nvim-treesitter-textobjects.move').goto_next_start('@class.outer', 'textobjects')
      end, { desc = 'Next class start' })
      -- You can also pass a list to group multiple queries.
      vim.keymap.set({ 'n', 'x', 'o' }, ']o', function()
        require('nvim-treesitter-textobjects.move').goto_next_start({ '@loop.inner', '@loop.outer' }, 'textobjects')
      end, { desc = 'Next loop start' })
      -- You can also use captures from other query groups like `locals.scm` or `folds.scm`
      vim.keymap.set({ 'n', 'x', 'o' }, ']s', function()
        require('nvim-treesitter-textobjects.move').goto_next_start('@local.scope', 'locals')
      end, { desc = 'Next local scope start' })
      vim.keymap.set({ 'n', 'x', 'o' }, ']z', function()
        require('nvim-treesitter-textobjects.move').goto_next_start('@fold', 'folds')
      end, { desc = 'Next fold start' })

      vim.keymap.set({ 'n', 'x', 'o' }, ']M', function()
        require('nvim-treesitter-textobjects.move').goto_next_end('@function.outer', 'textobjects')
      end, { desc = 'Next function end' })
      vim.keymap.set({ 'n', 'x', 'o' }, '][', function()
        require('nvim-treesitter-textobjects.move').goto_next_end('@class.outer', 'textobjects')
      end, { desc = 'Next class end' })

      vim.keymap.set({ 'n', 'x', 'o' }, '[m', function()
        require('nvim-treesitter-textobjects.move').goto_previous_start('@function.outer', 'textobjects')
      end, { desc = 'Previous function start' })
      vim.keymap.set({ 'n', 'x', 'o' }, '[[', function()
        require('nvim-treesitter-textobjects.move').goto_previous_start('@class.outer', 'textobjects')
      end, { desc = 'Previous class start' })

      vim.keymap.set({ 'n', 'x', 'o' }, '[s', function()
        require('nvim-treesitter-textobjects.move').goto_previous_start('@local.scope', 'locals')
      end, { desc = 'Previous local scope start' })

      vim.keymap.set({ 'n', 'x', 'o' }, '[M', function()
        require('nvim-treesitter-textobjects.move').goto_previous_end('@function.outer', 'textobjects')
      end, { desc = 'Previous function end' })
      vim.keymap.set({ 'n', 'x', 'o' }, '[]', function()
        require('nvim-treesitter-textobjects.move').goto_previous_end('@class.outer', 'textobjects')
      end, { desc = 'Previous class end' })

      -- Go to either the start or the end, whichever is closer.
      -- Use if you want more granular movements
      vim.keymap.set({ 'n', 'x', 'o' }, ']d', function()
        require('nvim-treesitter-textobjects.move').goto_next('@conditional.outer', 'textobjects')
      end, { desc = 'Next conditional (start or end)' })
      vim.keymap.set({ 'n', 'x', 'o' }, '[d', function()
        require('nvim-treesitter-textobjects.move').goto_previous('@conditional.outer', 'textobjects')
      end, { desc = 'Previous conditional (start or end)' })
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
