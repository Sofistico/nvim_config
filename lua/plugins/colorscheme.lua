return {
  { -- You can easily change to a different colorscheme.
    -- Change the name of the colorscheme plugin below, and then
    -- change the command in the config to whatever the name of that colorscheme is.
    --
    -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
    'folke/tokyonight.nvim',
    priority = 500, -- Make sure to load this before all the other start plugins.
    -- init = function()
    --   -- Load the colorscheme here.
    --   -- Like many other themes, this one has different styles, and you could load
    --   -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
    --   vim.cmd.colorscheme 'tokyonight-moon'
    --
    --   -- You can configure highlights by doing something like:
    --   vim.cmd.hi 'Comment gui=none'
    -- end,
  },

  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    opts = {
      integrations = {
        aerial = true,
        alpha = true,
        blink_cmp = true,
        cmp = true,
        dashboard = true,
        dadbod_ui = true,
        flash = true,
        fzf = true,
        grug_far = true,
        gitsigns = true,
        headlines = true,
        illuminate = true,
        indent_blankline = { enabled = true },
        leap = true,
        lsp_trouble = true,
        mason = true,
        markdown = true,
        mini = true,
        neotest = true,
        neotree = true,
        noice = true,
        notify = true,
        semantic_tokens = true,
        snacks = true,
        telescope = true,
        treesitter_context = true,
        which_key = true,
      },
      custom_highlights = function(C)
        local O = require('catppuccin').options
        return {
          ['@variable.member'] = { fg = C.lavender }, -- For fields.
          ['@module'] = { fg = C.lavender, style = O.styles.miscs or { 'italic' } }, -- For identifiers referring to modules and namespaces.
          ['@string.special.url'] = { fg = C.rosewater, style = { 'italic', 'underline' } }, -- urls, links and emails
          ['@type.builtin'] = { fg = C.yellow, style = O.styles.properties or { 'italic' } }, -- For builtin types.
          ['@property'] = { fg = C.lavender, style = O.styles.properties or {} }, -- Same as TSField.
          ['@constructor'] = { fg = C.sapphire }, -- For constructor calls and definitions: = { } in Lua, and Java constructors.
          ['@lsp.type.interface'] = { fg = C.flamingo },
          ['@keyword.operator'] = { link = 'Operator' }, -- For new keyword operator
          ['@keyword.export'] = { fg = C.sky, style = O.styles.keywords },
          ['@markup.strong'] = { fg = C.maroon, style = { 'bold' } }, -- bold
          ['@markup.italic'] = { fg = C.maroon, style = { 'italic' } }, -- italic
          ['@markup.heading'] = { fg = C.blue, style = { 'bold' } }, -- titles like: # Example
          ['@markup.quote'] = { fg = C.maroon, style = { 'bold' } }, -- block quotes
          ['@markup.link'] = { link = 'Tag' }, -- text references, footnotes, citations, etc.
          ['@markup.link.label'] = { link = 'Label' }, -- link, reference descriptions
          ['@markup.link.url'] = { fg = C.rosewater, style = { 'italic', 'underline' } }, -- urls, links and emails
          ['@markup.raw'] = { fg = C.teal }, -- used for inline code in markdown and for doc in python (""")
          ['@markup.list'] = { link = 'Special' },
          ['@tag'] = { fg = C.mauve }, -- Tags like html tag names.
          ['@tag.attribute'] = { fg = C.teal, style = O.styles.miscs or { 'italic' } }, -- Tags like html tag names.
          ['@tag.delimiter'] = { fg = C.sky }, -- Tag delimiter like < > /
          ['@property.css'] = { fg = C.lavender },
          ['@property.id.css'] = { fg = C.blue },
          ['@type.tag.css'] = { fg = C.mauve },
          ['@string.plain.css'] = { fg = C.peach },
          ['@constructor.lua'] = { fg = C.flamingo }, -- For constructor calls and definitions: = { } in Lua.
          -- typescript
          ['@property.typescript'] = { fg = C.lavender, style = O.styles.properties or {} },
          ['@constructor.typescript'] = { fg = C.lavender },
          -- TSX (Typescript React)
          ['@constructor.tsx'] = { fg = C.lavender },
          ['@tag.attribute.tsx'] = { fg = C.teal, style = O.styles.miscs or { 'italic' } },
          ['@type.builtin.c'] = { fg = C.yellow, style = {} },
          ['@type.builtin.cpp'] = { fg = C.yellow, style = {} },
        }
      end,
    },
    init = function()
      vim.cmd.colorscheme 'catppuccin-mocha'
    end,
    specs = {
      {
        'akinsho/bufferline.nvim',
        optional = true,
        opts = function(_, opts)
          if (vim.g.colors_name or ''):find 'catppuccin' then
            opts.highlights = require('catppuccin.special.bufferline').get_theme()
          end
        end,
      },
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
