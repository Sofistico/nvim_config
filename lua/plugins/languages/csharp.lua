local dap_helper = require 'util.self_dap'

-- dll third
local function select_dll_csharp()
  return dap_helper.select_execution '**/bin/Debug/**/*.dll'
end

-- path second
local function get_dll_csproj_path()
  select_dll_csharp()
  if not dap_helper.proj_name or dap_helper.proj_name == 'null' then
    vim.notify(dap_helper.proj_name)
    vim.notify 'using workspace folder as path'
    return '${workspaceFolder}'
  end
  vim.notify('using the path for the project: ' .. dap_helper.proj_name)
  return dap_helper.proj_name
end

-- env goes first
local function get_dll_env()
  local vars = dap_helper.get_environment_variables(get_dll_csproj_path(), false)
  return vars or nil
end

local function select_last_dll_csharp()
  return dap_helper.dll
end

return {
  -- {
  --   'stevearc/conform.nvim',
  --   optional = true,
  --   opts = {
  --     formatters_by_ft = {
  --       cs = { 'csharpier' },
  --     },
  --   },
  -- },
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
            detached = false, -- Will put the output in the REPL.
          },
        }
      end
      -- if not dap.adapters['sharpdbg'] then
      --   require('dap').adapters['sharpdbg'] = {
      --     type = 'executable',
      --     command = vim.fn.stdpath('data') .. '/sharpdbg/SharpDbg.Cli.exe',
      --     args = { '--interpreter=vscode' },
      --     options = {
      --       detached = false, -- Will put the output in the REPL.
      --     },
      --   }
      -- end
      for _, lang in ipairs { 'cs', 'fsharp', 'vb' } do
        if not dap.configurations[lang] then
          dap.configurations[lang] = {
            {
              type = 'coreclr',
              name = 'Attach to C# Process',
              request = 'attach',
              processId = require('dap.utils').pick_process,
              cwd = '${workspaceFolder}',
            },
            {
              type = 'coreclr',
              name = 'Select C# Dll',
              request = 'launch',
              program = select_dll_csharp,
              cwd = get_dll_csproj_path,
              env = get_dll_env,
            },
            {
              type = 'coreclr',
              name = 'Reuse Dll',
              request = 'launch',
              cwd = get_dll_csproj_path,
              env = get_dll_env,
              program = select_last_dll_csharp,
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
      'citizenharris/neotest-dotnet',
    },
    opts = {
      adapters = {
        ['neotest-dotnet'] = {
          -- Here we can set options for neotest-dotnet
        },
      },
    },
  },
}
