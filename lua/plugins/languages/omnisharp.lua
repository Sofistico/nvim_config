local dap_helper = require 'util.self_dap'
local function select_dll_csharp()
  return dap_helper.select_execution '**/bin/Debug/**/*.dll'
end

local function get_dll_csproj_path()
  if not dap_helper.dll then
    return '${workspaceFolder}'
  end
  local dll = dap_helper.dll
  local tail = vim.fn.fnamemodify(dll, ':t:r')
  return vim.fn.fnamemodify(dap_helper.search_for('**/' .. tail .. '.csproj'), ':p:h')
end

return {
  {
    'Hoffs/omnisharp-extended-lsp.nvim',
    lazy = true,
    ft = 'cs',
    cond = not vim.g.use_roslyn,
  },
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
              type = 'coreclr',
              name = 'Select C# Dll',
              request = 'launch',
              cwd = get_dll_csproj_path,
              program = select_dll_csharp,
            },
            {
              type = 'coreclr',
              name = 'Attach to C# Process',
              request = 'attach',
              processId = require('dap.utils').pick_process,
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
    'MoaidHathot/dotnet.nvim',
    ft = 'cs',
    opts = {
      bootstrap = {
        auto_bootstrap = false, -- Automatically call "bootstrap" when creating a new file, adding a namespace and a class to the files
      },
    },
  },
}
