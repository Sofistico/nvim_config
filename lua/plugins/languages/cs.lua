return {
  {
    'Hoffs/omnisharp-extended-lsp.nvim',
    lazy = true,
    event = 'BufEnter *.cs',
  },
  -- {
  --   -- this is something that in csharp is not working as expected, need to rework this configs
  --   'nvimtools/none-ls.nvim',
  --   optional = true,
  --   lazy = true,
  --   -- cmd = 'StartNone',
  --   event = 'BufEnter *.cs',
  --   opts = function(_, opts)
  --     local nls = require 'null-ls'
  --     opts.sources = opts.sources or {}
  --     table.insert(opts.sources, nls.builtins.formatting.csharpier)
  --   end,
  -- },
  {
    'stevearc/conform.nvim',
    optional = true,
    lazy = true,
    opts = {
      formatters_by_ft = {
        cs = { 'csharpier' },
      },
      formatters = {
        csharpier = {
          command = 'dotnet-csharpier',
          args = { '--write-stdout' },
        },
      },
    },
  },
  {
    'mfussenegger/nvim-dap',
    lazy = true,
    optional = true,
    opts = function()
      local dap = require 'dap'
      if not dap.adapters['netcoredbg'] then
        require('dap').adapters['netcoredbg'] = {
          type = 'executable',
          command = vim.fn.exepath 'netcoredbg',
          args = { '--interpreter=vscode' },
          options = {
            detached = false,
          },
        }
      end
      for _, lang in ipairs { 'cs', 'fsharp', 'vb' } do
        if not dap.configurations[lang] then
          dap.configurations[lang] = {
            {
              type = 'netcoredbg',
              name = 'Launch file',
              request = 'launch',
              ---@diagnostic disable-next-line: redundant-parameter
              program = function()
                return vim.fn.input('Path to dll: ', vim.fn.getcwd() .. '/', 'file')
              end,
              -- The error is here for my debug problems:
              -- TODO: FIX THIS SHIT TO DEBUG!
              cwd = '${workspaceFolder}/Bin',
            },
          }
        end
      end
    end,
  },
  {
    'nvim-neotest/neotest',
    optional = true,
    -- lazy = true,
    -- event = 'VeryLazy',
    dependencies = {
      'Issafalcon/neotest-dotnet',
    },
    opts = {
      adapters = {
        ['neotest-dotnet'] = {
          -- Here we can set options for neotest-dotnet
        },
      },
    },
  },
  {
    'iabdelkareem/csharp.nvim',
    dependencies = {
      'williamboman/mason.nvim', -- Required, automatically installs omnisharp
      'mfussenegger/nvim-dap',
      'Tastyep/structlog.nvim', -- Optional, but highly recommended for debugging
    },
    event = 'BufEnter *.cs',
    opts = {
      lsp = { enable = false },
    },
    -- config = function()
    --   require('mason').setup() -- Mason setup must run before csharp, only if you want to use omnisharp
    --   local cs = require 'csharp'
    --   cs.setup {
    --     lsp = { enable = false },
    --   }
    --   vim.keymap.set('n', '<leader>dD', cs.debug_project, { desc = 'Debug csharp' })
    -- end,
  },
  {
    'MoaidHathot/dotnet.nvim',
    event = 'BufEnter *.cs',
    opts = {
      bootstrap = {
        auto_bootstrap = false, -- Automatically call "bootstrap" when creating a new file, adding a namespace and a class to the files
      },
    },
  },
}
