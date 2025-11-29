local dap_helper = require 'util.self_dap'
local function select_dll_csharp()
  return dap_helper.select_execution '**/bin/Debug/**/*.dll'
end

local function get_dll_proj_name()
  if not dap_helper.dll then
    select_dll_csharp()
  end
  local dll = dap_helper.dll
  local tail = vim.fn.fnamemodify(dll, ':t:r')
  return tail
end

local function get_dll_csproj_path()
  local proj_name = get_dll_proj_name()
  if not proj_name then
    return '${workspaceFolder}'
  end
  return vim.fn.fnamemodify(dap_helper.search_for('**/' .. proj_name .. '.csproj'), ':p:h')
end

local function get_dll_env()
  local dotnet = require 'easy-dotnet'
  local vars = dotnet.get_environment_variables(dap_helper.dll, get_dll_csproj_path(), false)
  return vars or nil
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
              env = get_dll_env,
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
    'GustavEikaas/easy-dotnet.nvim',
    ft = 'cs',
    lazy = true,
    dependencies = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope.nvim' },
    config = function()
      local function get_secret_path(secret_guid)
        local path = ''
        local home_dir = vim.fn.expand '~'
        if require('easy-dotnet.extensions').isWindows() then
          local secret_path = home_dir .. '\\AppData\\Roaming\\Microsoft\\UserSecrets\\' .. secret_guid .. '\\secrets.json'
          path = secret_path
        else
          local secret_path = home_dir .. '/.microsoft/usersecrets/' .. secret_guid .. '/secrets.json'
          path = secret_path
        end
        return path
      end

      local dotnet = require 'easy-dotnet'
      -- Options are not required
      dotnet.setup {
        test_runner = {
          ---@type "split" | "float" | "buf"
          viewmode = 'float',
          enable_buffer_test_execution = true, --Experimental, run tests directly from buffer
          noBuild = true,
          icons = {
            passed = '',
            skipped = '',
            failed = '',
            success = '',
            reload = '',
            test = '',
            sln = '󰘐',
            project = '󰘐',
            dir = '',
            package = '',
          },
          mappings = {
            run_test_from_buffer = { lhs = '<leader>r', desc = 'run test from buffer' },
            filter_failed_tests = { lhs = '<leader>fe', desc = 'filter failed tests' },
            debug_test = { lhs = '<leader>d', desc = 'debug test' },
            go_to_file = { lhs = 'g', desc = 'go to file' },
            run_all = { lhs = '<leader>R', desc = 'run all tests' },
            run = { lhs = '<leader>r', desc = 'run test' },
            peek_stacktrace = { lhs = '<leader>p', desc = 'peek stacktrace of failed test' },
            expand = { lhs = 'o', desc = 'expand' },
            expand_node = { lhs = 'E', desc = 'expand node' },
            expand_all = { lhs = '-', desc = 'expand all' },
            collapse_all = { lhs = 'W', desc = 'collapse all' },
            close = { lhs = 'q', desc = 'close testrunner' },
            refresh_testrunner = { lhs = '<C-r>', desc = 'refresh testrunner' },
          },
          --- Optional table of extra args e.g "--blame crash"
          additional_args = {},
        },
        new = {
          project = {
            prefix = 'sln', -- "sln" | "none"
          },
        },
        ---@param action "test" | "restore" | "build" | "run"
        terminal = function(path, action, args)
          local commands = {
            run = function()
              return string.format('dotnet run --project %s %s', path, args)
            end,
            test = function()
              return string.format('dotnet test %s %s', path, args)
            end,
            restore = function()
              return string.format('dotnet restore %s %s', path, args)
            end,
            build = function()
              return string.format('dotnet build %s %s', path, args)
            end,
            watch = function()
              return string.format('dotnet watch --project %s %s', path, args)
            end,
          }

          local command = commands[action]() .. '\r'
          vim.cmd 'vsplit'
          vim.cmd('term ' .. command)
        end,
        secrets = {
          path = get_secret_path,
        },
        notifications = {
          --ignoring the loading notification, just creates bloat for nothing
          handler = function(start_event)
            if start_event.job.name ~= 'Loading' then
              return
            end
            local spinner = require('easy-dotnet.ui-modules.spinner').new()
            spinner:start_spinner(start_event.job.name)
            ---@param finished_event JobEvent
            return function(finished_event)
              spinner:stop_spinner(finished_event.result.text, finished_event.result.level)
            end
          end,
        },
        csproj_mappings = true,
        fsproj_mappings = true,
        auto_bootstrap_namespace = {
          --block_scoped, file_scoped
          type = 'block_scoped',
          enabled = true,
        },
        -- choose which picker to use with the plugin
        -- possible values are "telescope" | "fzf" | "snacks" | "basic"
        -- if no picker is specified, the plugin will determine
        -- the available one automatically with this priority:
        -- telescope -> fzf -> snacks ->  basic
        picker = 'telescope',
        background_scanning = true,
        lsp = { enabled = false },
      }
    end,
  },
}
