-- NOTE: Plugins can also be configured to run Lua code when they are loaded.
--
-- This is often very useful to both group configuration, as well as handle
-- lazy loading plugins that don't need to be loaded immediately at startup.
--
-- For example, in the following configuration, we use:
--  event = 'VimEnter'
--
-- which loads which-key before all the UI elements are loaded. Events can be
-- normal autocommands events (`:help autocmd-events`).
--
-- Then, because we use the `config` key, the configuration only runs
-- after the plugin has been loaded:
--  config = function() ... end
local icon = require 'local-icons'
return {
  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VeryLazy', -- Sets the loading event to 'VimEnter'
    opts_extend = { 'spec' },
    opts = {
      preset = 'helix',
      -- delay between pressing a key and opening which-key (milliseconds)
      -- this setting is independent of vim.opt.timeoutlen
      delay = 0,
      spec = {
        mode = { 'n', 'v', 'x' },
        { '<leader>c', group = 'code' },
        -- { '<leader>d', group = '[D]ocument' },
        -- { '<leader>r', group = '[R]ename' },
        { '<leader>s', group = 'search' },
        -- { '<leader>w', group = '[W]orkspace' },
        { '<leader>t', group = 'toggle' },
        -- { '<leader>h', group = 'git hunk'}
        { '<leader><tab>', group = 'tabs' },
        {
          '<leader>b',
          group = 'buffers',
          expand = function()
            return require('which-key.extras').expand.buf()
          end,
        },
        { '<leader>g', group = 'git' },
        { '<leader>q', group = 'quit' },
        { '<leader>x', group = 'diagnostics' },
        { '<leader>n', group = 'notification' },
        { '<leader>r', group = '+refactoring' },
        { '<leader>d', group = '+debug' },
        { 'gp', group = 'preview' },
        { '[', group = 'prev' },
        { ']', group = 'next' },
        { 'g', group = 'goto' },
        { 'gs', group = 'surround' },
        { 'z', group = 'fold' },
        { 'gq', group = 'Builtin Formatter' },

        -- This here is just to make a beautiful name for keys:
        { '<c-w>r', desc = 'Rotate windows' },
        {'g-', desc = 'Go to older text state'},
        {'g+', desc = 'Go to newer text state'}
      },
      icons = {
        rules = {
          { pattern = 'home', icon = icon.house, color = 'blue' },
          { pattern = 'refactoring', icon = icon.init, color = 'violet' },
        },
        mappings = vim.g.have_nerd_font,
      },
    },
    config = function(_, opts)
      local wk = require 'which-key'
      wk.setup(opts)
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
