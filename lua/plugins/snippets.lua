local self_cmp = require 'util.self_cmp'
return {
  'nvim-cmp',
  dependencies = {
    {
      'garymjr/nvim-snippets',
      opts = {
        friendly_snippets = true,
      },
      dependencies = { 'rafamadriz/friendly-snippets' },
    },
  },
  opts = function(_, opts)
    table.insert(opts.sources, { name = 'lazydev', group_index = 0 })
    opts.snippet = {
      expand = function(item)
        return self_cmp.cmp.expand(item.body)
      end,
    }
    table.insert(opts.sources, { name = 'snippets' })
    local cmp = require 'cmp'
    table.insert(cmp.sources, { name = 'luasnip' })
  end,
  keys = {
    {
      '<Tab>',
      function()
        return vim.snippet.active { direction = 1 } and '<cmd>lua vim.snippet.jump(1)<cr>' or '<Tab>'
      end,
      expr = true,
      silent = true,
      mode = { 'i', 's' },
    },
    {
      '<S-Tab>',
      function()
        return vim.snippet.active { direction = -1 } and '<cmd>lua vim.snippet.jump(-1)<cr>' or '<S-Tab>'
      end,
      expr = true,
      silent = true,
      mode = { 'i', 's' },
    },
  },
  {
    'garymjr/nvim-snippets',
    opts = {
      friendly_snippets = true,
    },
    dependencies = { 'rafamadriz/friendly-snippets' },
    event = 'BufAdd',
  },
  { 'rafamadriz/friendly-snippets', lazy = true },
  {
    'L3MON4D3/LuaSnip',
    lazy = true,
    build = (function()
      -- Build Step is needed for regex support in snippets.
      -- This step is not supported in many windows environments.
      -- Remove the below condition to re-enable on windows.
      if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
        return
      end
      return 'make install_jsregexp'
    end)(),
    dependencies = {
      -- `friendly-snippets` contains a variety of premade snippets.
      --    See the README about individual language/framework/plugin snippets:
      --    https://github.com/rafamadriz/friendly-snippets
      {
        'rafamadriz/friendly-snippets',
        config = function()
          require('luasnip.loaders.from_vscode').lazy_load()
          require("luasnip").filetype_extend("cs", { "csharpdoc" })
        end,
      },
    },
    opts = {
      history = true,
      delete_check_events = 'TextChanged',
    },
  },
}
