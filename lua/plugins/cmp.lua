-- This isn't worth to get a plugin just for it
local function under(entry1, entry2)
  local _, entry1_under = entry1.completion_item.label:find '^_+'
  local _, entry2_under = entry2.completion_item.label:find '^_+'
  entry1_under = entry1_under or 0
  entry2_under = entry2_under or 0
  if entry1_under > entry2_under then
    return false
  elseif entry1_under < entry2_under then
    return true
  end
end

-- local function priorize_kind(kind)
--   return function(e1, e2)
--     if e1:get_kind() == kind then
--       return false
--     end
--     if e2:get_kind() == kind then
--       return true
--     end
--   end
-- end

return {
  { -- Autocompletion
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    cond = not vim.g.use_blink,
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      'garymjksdjalr/nvim-snippets',
      -- Adds other completion capabilities.
      --  nvim-cmp does not ship with all sources by default. They are split
      --  into multiple repos for maintenance purposes.
      'hrsh7th/cmp-nvim-lsp',
      'neovim/nvim-lspconfig',
      -- 'hrsh7th/cmp-nvim-lsp-signature-help',
      'hrsh7th/cmp-path',
    },
    opts = function()
      -- See `:help cmp`
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'

      luasnip.config.setup()

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = { completeopt = 'menu,menuone,noinsert' },

        -- For an understanding of why these mappings were
        -- chosen, you will need to read `:help ins-completion`
        --
        -- No, but seriously. Please read `:help ins-completion`, it is really good!
        mapping = cmp.mapping.preset.insert {
          -- Select the [n]ext item
          ['<C-n>'] = cmp.mapping.select_next_item(),
          -- Select the [p]revious item
          ['<C-p>'] = cmp.mapping.select_prev_item(),

          -- Scroll the documentation window [b]ack / [f]orward
          -- ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          -- ['<C-f>'] = cmp.mapping.scroll_docs(4),

          -- Accept ([y]es) the completion.
          --  This will auto-import if your LSP supports it.
          --  This will expand snippets if the LSP sent a snippet.
          ['<C-k>'] = cmp.mapping.confirm { select = true, behavior = cmp.ConfirmBehavior.Insert },

          -- If you prefer more traditional completion keymaps,
          -- you can uncomment the following lines
          -- ['<CR>'] = cmp.mapping.confirm { select = true, behavior = cmp.ConfirmBehavior.Insert },
          ['<Tab>'] = cmp.mapping.confirm { select = true, behavior = cmp.ConfirmBehavior.Insert },

          -- Manually trigger a completion from nvim-cmp.
          --  Generally you don't need this, because nvim-cmp will display
          --  completions whenever it has completion options available.
          ['<C-j>'] = cmp.mapping.complete {},

          -- Think of <c-l> as moving to the right of your snippet expansion.
          --  So if you have a snippet that's like:
          --  function $name($args)
          --    $body
          --  end
          --
          -- <c-l> will move you to the right of each of the expansion locations.
          -- <c-h> is similar, except moving you backwards.
          ['<C-l>'] = cmp.mapping(function()
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { 'i', 's' }),
          ['<C-h>'] = cmp.mapping(function()
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { 'i', 's' }),

          -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
          --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
        },
        sources = {
          -- { name = 'nvim_lsp_signature_help' },
          { name = 'nvim_lsp', priority = 9 },
          {
            name = 'lazydev',
            -- set group index to 0 to skip loading LuaLS completions as lazydev recommends it
            group_index = 0,
            priority = 2,
          },
          { name = 'luasnip', priority = 7 },
          { name = 'path', priority = 5 },
          { name = 'nvim-lua', priority = 1 },
        },
        ---@diagnostic disable-next-line: missing-fields
        formatting = {
          format = function(entry, list)
            local icons = require 'local-icons'
            list.kind = (icons.kinds[list.kind] or 'Foo') .. list.kind

            -- list.menu = ({
            --   nvim_lsp = '[LSP]',
            --   vsnip = '[Snippet]',
            --   nvim_lua = '[Nvim Lua]',
            --   buffer = '[Buffer]',
            -- })[entry.source.name]

            list.dup = ({
              nvim_lsp = 0,
            })[entry.source.name] or 0

            return list
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        -- performance = {
        --   max_view_entries = 15,
        -- }
        sorting = {
          priority_weight = 1.0,
          comparators = {
            cmp.config.compare.exact,
            cmp.config.compare.score,
            cmp.config.compare.offset,
            cmp.config.compare.kind,
            under,
            cmp.config.compare.locality,
            cmp.config.compare.recently_used,
            -- cmp.config.compare.sort_text,
            -- cmp.config.compare.length,
            -- cmp.config.compare.order,
          },
        },
      }
    end,
  },
  {
    'saghen/blink.cmp',
    -- optional: provides snippets for the snippet source
    dependencies = { 'rafamadriz/friendly-snippets' },
    cond = vim.g.use_blink,
    -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    build = 'cargo build --release',
    event = 'InsertEnter',
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
      -- 'super-tab' for mappings similar to vscode (tab to accept)
      -- 'enter' for enter to accept
      -- 'none' for no mappings
      --
      -- All presets have the following mappings:
      -- C-space: Open menu or open docs if already open
      -- C-n/C-p or Up/Down: Select next/previous item
      -- C-e: Hide menu
      -- C-k: Toggle signature help (if signature.enabled = true)
      --
      -- See :h blink-cmp-config-keymap for defining your own keymap
      keymap = {
        preset = 'default',
        ['<C-k>'] = { 'select_and_accept' },
        ['<C-l>'] = { 'snippet_forward' },
        ['<C-h>'] = { 'snippet_backward' },
        ['<C-j>'] = { 'show' },
        ['<Tab>'] = { 'select_and_accept', 'fallback' },
        -- ['<c-d>'] = { 'show_documentation', 'hide_documentation' },
      },

      appearance = {
        -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = 'mono',
      },

      completion = {
        documentation = { auto_show = true, window = { border = 'rounded' } },
        accept = { resolve_timeout_ms = 1000 },
        menu = {
          border = 'rounded',
          draw = {
            columns = { { 'label', 'label_description', gap = 1 }, { 'kind_icon', 'kind', gap = 1 } },
            components = {
              kind_icon = {
                text = function(ctx)
                  local icons = require 'local-icons'
                  local kind_icon = icons.kinds[ctx.kind] or 'foo'
                  return kind_icon
                end,
                -- (optional) use highlights from mini.icons
                highlight = function(ctx)
                  local _, hl, _ = require('mini.icons').get('lsp', ctx.kind)
                  return hl
                end,
              },
              kind = {
                -- (optional) use highlights from mini.icons
                highlight = function(ctx)
                  local _, hl, _ = require('mini.icons').get('lsp', ctx.kind)
                  return hl
                end,
              },
            },
          },
        },
      },
      signature = { enabled = false, window = { border = 'rounded' } },

      -- Default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, due to `opts_extend`
      sources = {
        -- `lsp`, `buffer`, `snippets`, `path` and `omni` are built-in
        -- so you don't need to define them in `sources.providers`
        default = { 'lsp', 'buffer', 'snippets', 'path' },

        per_filetype = { sql = { 'dadbod' } },
        providers = {
          dadbod = { module = 'vim_dadbod_completion.blink' },
          lsp = {
            transform_items = function(_, items)
              for _, item in ipairs(items) do
                local cmp_item_kind = require('blink.cmp.types').CompletionItemKind

                if item.kind == cmp_item_kind.Property or item.kind == cmp_item_kind.Field then
                  item.score_offset = item.score_offset + 1
                end

                if item.kind == cmp_item_kind.Operator then
                  item.score_offset = item.score_offset - 1
                end
              end

              return vim.tbl_filter(function(item)
                return item.kind ~= require('blink.cmp.types').CompletionItemKind.Text
              end, items)
            end,
          },
        },
      },
      cmdline = { enabled = false },
      snippets = { preset = 'luasnip' },

      -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
      -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
      -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
      --
      -- See the fuzzy documentation for more information
      fuzzy = {
        implementation = 'prefer_rust_with_warning',
        sorts = {
          'exact',
          -- defaults
          'score',
          'kind',
          'sort_text',
        },
      },
    },
    opts_extend = { 'sources.default' },
  },
}
-- vim: ts=2 sts=2 sw=2 et
