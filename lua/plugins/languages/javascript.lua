local self_init = require 'util.self_init'
return {
  {
    'mfussenegger/nvim-dap',
    ft = { 'js', 'ts', 'jsx' },
    optional = true,
    lazy = true,
    specs = {
      -- Ensure JS debugger is installed
      'williamboman/mason.nvim',
      optional = true,
      opts = { ensure_installed = { 'js-debug-adapter' } },
    },
    opts = function()
      local dap = require 'dap'
      if not dap.adapters['pwa-node'] then
        require('dap').adapters['pwa-node'] = {
          type = 'server',
          host = 'localhost',
          port = '${port}',
          executable = {
            command = 'node',
            -- 💀 Make sure to update this path to point to your installation
            args = {
              self_init.get_pkg_path('js-debug-adapter', '/js-debug/src/dapDebugServer.js', { warn = false }),
              '${port}',
            },
          },
        }
      end
      if not dap.adapters['node'] then
        dap.adapters['node'] = function(cb, config)
          if config.type == 'node' then
            config.type = 'pwa-node'
          end
          local nativeAdapter = dap.adapters['pwa-node']
          if type(nativeAdapter) == 'function' then
            nativeAdapter(cb, config)
          else
            cb(nativeAdapter)
          end
        end
      end
      local js_filetypes = { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact' }

      local vscode = require 'dap.ext.vscode'
      vscode.type_to_filetypes['node'] = js_filetypes
      vscode.type_to_filetypes['pwa-node'] = js_filetypes

      for _, language in ipairs(js_filetypes) do
        if not dap.configurations[language] then
          dap.configurations[language] = {
            {
              type = 'pwa-node',
              request = 'launch',
              name = 'Launch file pwa-node',
              program = '${file}',
              cwd = '${workspaceFolder}',
              sourceMaps = true,
            },
            {
              type = 'pwa-node',
              request = 'attach',
              name = 'Attach',
              processId = require('dap.utils').pick_process,
              cwd = '${workspaceFolder}',
              sourceMaps = true,
            },
            -- Debug web applications (client side)
            {
              type = 'pwa-chrome',
              request = 'launch',
              name = 'Launch & Debug Chrome',
              url = function()
                local co = coroutine.running()
                return coroutine.create(function()
                  vim.ui.input({
                    prompt = 'Enter URL: ',
                    default = 'http://localhost:3000',
                  }, function(url)
                    if url == nil or url == '' then
                      return
                    else
                      coroutine.resume(co, url)
                    end
                  end)
                end)
              end,
              webRoot = vim.fn.getcwd(),
              protocol = 'inspector',
              sourceMaps = true,
              userDataDir = false,
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
}
