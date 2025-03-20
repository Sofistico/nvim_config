local lsp = require 'util.self_lsp'
local helpers = require 'util.self_init'

return {
  {
    'seblyng/roslyn.nvim',
    ft = { 'cs', 'razor' },
    keys = {
      {
        '<leader>tT',
        '<cmd>Roslyn target<cr>',
        desc = 'Target solution C#',
      },
    },
    dependencies = {
      {
        -- By loading as a dependencies, we ensure that we are available to set
        -- the handlers for roslyn
        'tris203/rzls.nvim',
        config = function()
          ---@diagnostic disable-next-line: missing-fields
          require('rzls').setup {}
        end,
      },
    },
    init = function()
      -- we add the razor filetypes before the plugin loads
      vim.filetype.add {
        extension = {
          razor = 'razor',
          cshtml = 'razor',
        },
      }
    end,
    config = function()
      local roslyn = require 'roslyn'

      ---@module 'roslyn.config'
      ---@class RoslynNvimConfig
      local roslyn_config = {
        args = {
          '--stdio',
          '--logLevel=Information',
          '--extensionLogDirectory=' .. vim.fs.dirname(vim.lsp.get_log_path()),
          '--razorSourceGenerator='
            .. vim.fs.joinpath(vim.fn.stdpath 'data' --[[@as string]], 'mason', 'packages', 'roslyn', 'libexec', 'Microsoft.CodeAnalysis.Razor.Compiler.dll'),
          '--razorDesignTimePath=' .. vim.fs.joinpath(
            vim.fn.stdpath 'data' --[[@as string]],
            'mason',
            'packages',
            'rzls',
            'libexec',
            'Targets',
            'Microsoft.NET.Sdk.Razor.DesignTime.targets'
          ),
        },
        ---@diagnostic disable-next-line: missing-fields
        config = {
          handlers = require 'rzls.roslyn_handlers',
          settings = {
            ['csharp|inlay_hints'] = {
              csharp_enable_inlay_hints_for_implicit_object_creation = true,
              csharp_enable_inlay_hints_for_implicit_variable_types = true,
              csharp_enable_inlay_hints_for_lambda_parameter_types = true,
              csharp_enable_inlay_hints_for_types = true,
              dotnet_enable_inlay_hints_for_indexer_parameters = true,
              dotnet_enable_inlay_hints_for_literal_parameters = true,
              dotnet_enable_inlay_hints_for_object_creation_parameters = true,
              dotnet_enable_inlay_hints_for_other_parameters = true,
              dotnet_enable_inlay_hints_for_parameters = true,
              dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
              dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
              dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
            },
            ['csharp|code_lens'] = {
              dotnet_enable_references_code_lens = true,
            },
            ['csharp|completion'] = {
              dotnet_show_completion_items_from_unimported_namespaces = true,
            },
            ['csharp|symbol_search'] = {
              dotnet_search_reference_assemblies = true,
            },
          },
        },
        broad_search = true,
      }

      if helpers.is_loaded 'rzls.roslyn_handlers' then
        roslyn_config.config.handlers = require 'rzls.roslyn_handlers'
      end

      roslyn.setup(roslyn_config)

      require('telescope').setup {
        defaults = {
          file_ignore_patterns = { '%__virtual.cs$' },
        },
      }
      require('trouble').setup {
        modes = {
          diagnostics = {
            filter = function(items)
              return vim.tbl_filter(function(item)
                return not string.match(item.basename, [[%__virtual.cs$]])
              end, items)
            end,
          },
        },
      }

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('roslyn-lsp-attach', { clear = true }),
        callback = function(event)
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          lsp.monkey_patch_semantic_tokens(client)

          -- diagnostic refresh
          vim.api.nvim_create_autocmd({ 'InsertLeave' }, {
            group = vim.api.nvim_create_augroup('roslyn-proper-diag-change', { clear = true }),
            pattern = '*',
            callback = function()
              local clients = vim.lsp.get_clients { name = 'roslyn' }
              if not clients or #clients == 0 then
                return
              end

              local buffers = vim.lsp.get_buffers_by_client_id(clients[1].id)
              for _, buf in ipairs(buffers) do
                vim.lsp.util._refresh('textDocument/diagnostic', { bufnr = buf })
              end
            end,
          })
        end,
      })
    end,
  },
}
