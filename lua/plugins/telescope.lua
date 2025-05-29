-- NOTE: Plugins can specify dependencies.
--
-- The dependencies are proper plugin specifications as well - anything
-- you do for a plugin at the top level, you can do for a dependency.
--
-- Use the `dependencies` key to specify the dependencies of a particular plugin

return {
  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    event = 'VeryLazy',
    -- branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { -- If encountering errors, see telescope-fzf-native README for installation instructions
        'nvim-telescope/telescope-fzf-native.nvim',

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = 'make',

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },

      -- Useful for getting pretty icons, but requires a Nerd Font.
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      -- Telescope is a fuzzy finder that comes with a lot of different things that
      -- it can fuzzy find! It's more than just a "file finder", it can search
      -- many different aspects of Neovim, your workspace, LSP, and more!
      --
      -- The easiest way to use Telescope, is to start by doing something like:
      --  :Telescope help_tags
      --
      -- After running this command, a window will open up and you're able to
      -- type in the prompt window. You'll see a list of `help_tags` options and
      -- a corresponding preview of the help.
      --
      -- Two important keymaps to use while in Telescope are:
      --  - Insert mode: <c-/>
      --  - Normal mode: ?
      --
      -- This opens a window that shows you all of the keymaps for the current
      -- Telescope picker. This is really useful to discover what Telescope can
      -- do as well as how to actually do it!

      -- [[ Configure Telescope ]]
      -- See `:help telescope` and `:help telescope.setup()`
      require('telescope').setup {
        -- You can put your default mappings / updates / etc. in here
        --  All the info you're looking for is in `:help telescope.setup()`
        --
        -- defaults = {
        --   mappings = {
        --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
        --   },
        -- },
        -- pickers = {}
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
        defaults = {
          -- path_display = { 'smart' }, -- if it becomes to slow, consider switching to truncate or shorten. see telescope.setup
          -- path_display = function(_, path)
          --   local tail = require('telescope.utils').path_tail(path)
          --   return string.format('%s (%s)', tail, path)
          -- end,
          layout_strategy = 'vertical',
          mappings = {
            i = {
              ['<c-s>'] = require('telescope.actions').file_split,
              ['<c-v>'] = require('telescope.actions').file_vsplit,
              ['<c-x>'] = false,
              ['<c-k>'] = require('telescope.actions').select_default,
              ['<a-a>'] = function()
                local builtin = require 'telescope.builtin'
                builtin.find_files { hidden = true }
              end,
            },
            n = {
              ['q'] = require('telescope.actions').close,
              ['<c-x>'] = false,
              ['<c-s>'] = require('telescope.actions').file_split,
              ['<c-v>'] = require('telescope.actions').file_vsplit,
              ['<c-k>'] = require('telescope.actions').select_default,
            },
          },
        },
      }

      -- Enable Telescope extensions if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      -- See `:help telescope.builtin`
      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>st', builtin.builtin, { desc = '[S]earch Select [T]elescope' })
      vim.keymap.set('n', '<leader>sR', builtin.reloader, { desc = '[S]earch [R]eloader' })
      vim.keymap.set({ 'v', 'n' }, '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader>sl', builtin.resume, { desc = '[S]earch Last Telescope' })
      vim.keymap.set('n', '<leader>sb', function()
        builtin.buffers { ignore_current_buffer = true, sort_mru = true, path_display = { 'smart' } }
      end, { desc = '[S]earch existing [B]uffers' })
      vim.keymap.set('n', '<leader>sG', builtin.git_status, { desc = '[S]earch [G]it Status' })
      vim.keymap.set('n', '<leader>sc', builtin.colorscheme, { desc = '[S]earch [C]olorscheme' })

      -- Slightly advanced example of overriding default behavior and theme
      vim.keymap.set('n', '\\', function()
        -- You can pass additional configuration to Telescope to change the theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[ ] Fuzzily search in current buffer' })

      -- It's also possible to pass additional configuration options.
      --  See `:help telescope.builtin.live_grep()` for information about particular keys
      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[S]earch [/] in Open Files' })

      -- Shortcut for searching your Neovim configuration files
      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[S]earch [N]eovim files' })

      vim.keymap.set('n', '<leader>sm', require('util.self_telescope').live_multigrep, { desc = '[S]earch [M]ultiGrep' })
    end,
  },
}
