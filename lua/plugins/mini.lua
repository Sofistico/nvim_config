local self_mini = require 'util.self_mini'
local self_init = require 'util.self_init'
return {
  {
    'nvim-mini/mini.statusline',
    lazy = true,
    event = 'VeryLazy',
    config = function()
      -- Simple and easy statusline.
      --  You could remove this setup call if you don't like it,
      --  and try some other statusline plugin
      local statusline = require 'mini.statusline'
      -- set use_icons to true if you have a Nerd Font
      statusline.setup { use_icons = vim.g.have_nerd_font }

      -- You can configure sections in the statusline by overriding their
      -- default behavior. For example, here we set the section for
      -- cursor location to LINE:COLUMN
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v ' .. ' ' .. os.date '%R'
      end

      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_filename = function(args)
        -- In terminal always use plain name
        if vim.bo.buftype == 'terminal' or statusline.is_truncated(args.trunc_width) then
          return '%t'
        else
          -- Use fullpath if not truncated
          return vim.fn.expand '%:~:.' .. '%m%r'
        end
      end

      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_lsp = function(args)
        if statusline.is_truncated(args.trunc_width) then
          return ''
        end
        local clients = vim.lsp.get_clients { bufnr = vim.api.nvim_get_current_buf() }
        if vim.tbl_count(clients) == 0 then
          return ''
        end
        local icon = vim.g.have_nerd_font and '󰰎' or 'LSP'
        local attached = icon
        for _, client in pairs(clients) do
          attached = attached .. ' ' .. client.name
        end
        return attached
      end
    end,
  },
  {
    'nvim-mini/mini.ai',
    lazy = true,
    event = 'InsertEnter',
    opts = function()
      local ai = require 'mini.ai'
      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter { -- code block
            a = { '@block.outer', '@conditional.outer', '@loop.outer' },
            i = { '@block.inner', '@conditional.inner', '@loop.inner' },
          },
          f = ai.gen_spec.treesitter { a = '@function.outer', i = '@function.inner' }, -- function
          c = ai.gen_spec.treesitter { a = '@class.outer', i = '@class.inner' }, -- class
          t = { '<([%p%w]-)%f[^<%w][^<>]->.-</%1>', '^<.->().*()</[^/]->$' }, -- tags
          d = { '%f[%d]%d+' }, -- digits
          e = { -- Word with case
            { '%u[%l%d]+%f[^%l%d]', '%f[%S][%l%d]+%f[^%l%d]', '%f[%P][%l%d]+%f[^%l%d]', '^[%l%d]+%f[^%l%d]' },
            '^().*()$',
          },
          i = self_mini.ai_indent, -- indent
          g = self_mini.ai_buffer, -- buffer
          u = ai.gen_spec.function_call(), -- u for "Usage"
          U = ai.gen_spec.function_call { name_pattern = '[%w_]' }, -- without dot in function name
        },
        use_nvim_treesitter = true,
      }
    end,
    config = function(_, opts)
      require('mini.ai').setup(opts)
      self_init.on_load('which-key.nvim', function()
        vim.schedule(function()
          self_mini.ai_whichkey(opts)
        end)
      end)
    end,
  },
  {
    'nvim-mini/mini.icons',
    opts = {
      file = {
        ['.keep'] = { glyph = '󰊢', hl = 'MiniIconsGrey' },
        ['devcontainer.json'] = { glyph = '', hl = 'MiniIconsAzure' },
      },
      filetype = {
        dotenv = { glyph = '', hl = 'MiniIconsYellow' },
        csharp = { glyph = '󰌛', hl = 'MiniIconsGreen' },
        cshtml = { glyph = '', hl = 'MiniIconsAzure' },
        razor = { glyph = '', hl = 'MiniIconsAzure' },
      },
    },
    init = function()
      package.preload['nvim-web-devicons'] = function()
        require('mini.icons').mock_nvim_web_devicons()
        return package.loaded['nvim-web-devicons']
      end
    end,
  },
  {
    'nvim-mini/mini.surround',
    lazy = true,
    event = 'BufAdd',
    opts = {
      mappings = {
        add = 'gsa', -- Add surrounding in Normal and Visual modes
        delete = 'gsd', -- Delete surrounding
        find = 'gsf', -- Find surrounding (to the right)
        find_left = 'gsF', -- Find surrounding (to the left)
        highlight = 'gsh', -- Highlight surrounding
        replace = 'gsr', -- Replace surrounding
        update_n_lines = 'gsn', -- Update `n_lines`

        suffix_last = 'l', -- Suffix to search with "prev" method
        suffix_next = 'n', -- Suffix to search with "next" method
      },
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
