local dap_helper = require 'util.self_dap'

-- dll third
local function select_dll_csharp(project_only)
  return dap_helper.select_execution('**/bin/Debug/**/*.dll', project_only)
end

-- path second
local function get_dll_csproj_path(project_only)
  if project_only then
    return dap_helper.select_project_value('**/bin/Debug/**/*.dll', function(candidate)
      return candidate.project
    end)
  end

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
local function get_dll_env(project_only)
  if project_only then
    return coroutine.create(function(dap_run_co)
      dap_helper.with_project_selection('**/bin/Debug/**/*.dll', function(candidate)
        if not candidate then
          coroutine.resume(dap_run_co, nil)
          return
        end

        local env_co = dap_helper.get_environment_variables(candidate.project, false)
        coroutine.resume(env_co, dap_run_co)
      end)
    end)
  end

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
      dap.listeners.after.event_initialized['dotnet_project_picker'] = function()
        dap_helper.reset_project_selection()
      end
      dap.listeners.after.event_terminated['dotnet_project_picker'] = function()
        dap_helper.reset_project_selection()
      end
      dap.listeners.after.event_exited['dotnet_project_picker'] = function()
        dap_helper.reset_project_selection()
      end
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
              name = '1 - Smart Picker',
              request = 'launch',
              program = function()
                return select_dll_csharp(true)
              end,
              cwd = function()
                return get_dll_csproj_path(true)
              end,
              env = function()
                return get_dll_env(true)
              end,
            },
            {
              type = 'coreclr',
              name = '2 - Attach to C# Process',
              request = 'attach',
              processId = require('dap.utils').pick_process,
              cwd = '${workspaceFolder}',
            },
            {
              type = 'coreclr',
              name = '3 - Select C# Dll',
              request = 'launch',
              program = select_dll_csharp,
              cwd = get_dll_csproj_path,
              env = get_dll_env,
            },
            {
              type = 'coreclr',
              name = '4 - Reuse Dll',
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
      'nsidorenco/neotest-vstest',
    },
    opts = {
      adapters = {
        ['neotest-vstest'] = {
          -- Here we can set options for neotest-dotnet
        },
      },
    },
  },
}
