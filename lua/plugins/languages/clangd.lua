return {
  {
    'p00f/clangd_extensions.nvim',
    lazy = true,
    ft = { 'c', 'cpp' },
    config = function() end,
    opts = {
      inlay_hints = {
        inline = false,
      },
      ast = {
        --These require codicons (https://github.com/microsoft/vscode-codicons)
        role_icons = {
          type = '',
          declaration = '',
          expression = '',
          specifier = '',
          statement = '',
          ['template argument'] = '',
        },
        kind_icons = {
          Compound = '',
          Recovery = '',
          TranslationUnit = '',
          PackExpansion = '',
          TemplateTypeParm = '',
          TemplateTemplateParm = '',
          TemplateParamObject = '',
        },
      },
    },
  },
  {
    'mfussenegger/nvim-dap',
    ft = { 'c', 'cpp' },
    optional = true,
    dependencies = {
      -- Ensure C/C++ debugger is installed
      'williamboman/mason.nvim',
      optional = true,
      opts = { ensure_installed = { 'codelldb' } },
    },
    opts = function()
      local dap = require 'dap'
      if not dap.adapters['codelldb'] then
        require('dap').adapters['codelldb'] = {
          -- type = 'server',
          -- host = 'localhost',
          -- port = '${port}',
          -- executable = {
          --   command = 'codelldb',
          --   args = {
          --     '--port',
          --     '${port}',
          --   },
          -- },
          type = 'executable',
          command = 'codelldb', -- or if not in $PATH: "/absolute/path/to/codelldb"
        }
      end
      for _, lang in ipairs { 'c', 'cpp' } do
        dap.configurations[lang] = {
          {
            type = 'codelldb',
            request = 'launch',
            name = 'Launch file',
            program = function()
              return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
            end,
            cwd = '${workspaceFolder}',
          },
          {
            type = 'codelldb',
            request = 'attach',
            name = 'Attach to process',
            pid = require('dap.utils').pick_process,
            cwd = '${workspaceFolder}',
          },
          -- Divider for the launch.json derived configs
          {
            name = '----- ↓ launch.json configs ↓ -----',
            type = '',
            request = 'launch',
          },
        }
      end
    end,
  },
}
