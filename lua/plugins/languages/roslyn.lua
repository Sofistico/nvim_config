local lsp = require 'util.self_lsp'
local helpers = require 'util.self_init'

return {
  {
    'seblyng/roslyn.nvim',
    ft = { 'cs', 'razor' },
    cond = vim.g.use_roslyn,
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
      local data = vim.fn.stdpath 'data' --[[@as string]]
      local libs_path = vim.fs.joinpath(data, 'mason', 'packages', 'roslyn', 'libexec')

      local mason_registry = require 'mason-registry'

      ---@type string[]
      local cmd = {}

      local roslyn_package = mason_registry.get_package 'roslyn'
      if roslyn_package:is_installed() then
        vim.list_extend(cmd, {
          'dotnet',
          '--stdio',
          '--logLevel=Information',
          '--extensionLogDirectory=' .. vim.fs.dirname(vim.lsp.get_log_path()),
        })

        local rzls_package = mason_registry.get_package 'rzls'
        if rzls_package:is_installed() then
          local rzls_path = vim.fn.expand '$MASON/packages/rzls/libexec'
          table.insert(cmd, '--razorSourceGenerator=' .. vim.fs.joinpath(rzls_path, 'Microsoft.CodeAnalysis.Razor.Compiler.dll'))
          table.insert(cmd, '--razorDesignTimePath=' .. vim.fs.joinpath(rzls_path, 'Targets', 'Microsoft.NET.Sdk.Razor.DesignTime.targets'))
        end
      end

      ---@module 'roslyn.config'
      ---@class RoslynNvimConfig
      local roslyn_config = {
        cmd = cmd,
        filewatching = 'roslyn',
        ---@diagnostic disable-next-line: missing-fields
        config = {
          autostart = vim.g.use_roslyn,
          filetypes = { 'cs', 'razor' },
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
            ['csharp|background_analysis'] = {
              dotnet_analyzer_diagnostics_scope = 'openFiles',
              dotnet_compiler_diagnostics_scope = 'openFiles',
            },
            ['csharp|code_lens'] = {
              dotnet_enable_references_code_lens = true,
            },
            ['csharp|completion'] = {
              dotnet_show_completion_items_from_unimported_namespaces = true,
              dotnet_show_name_completion_suggestions = true,
            },
            ['csharp|symbol_search'] = {
              dotnet_search_reference_assemblies = true,
            },
            ['csharp|formatting'] = {
              dotnet_organize_imports_on_format = true,
            },
            ['csharp|quick_info'] = {
              dotnet_show_remarks_in_quick_info = true,
            },
            ['csharp|type_members'] = {
              dotnet_member_insertion_location = 'with_other_members_of_the_same_kind',
            },
          },
        },
        broad_search = true,
        choose_target = function(targets)
          local current_sln = vim.g.roslyn_nvim_selected_solution
          if current_sln == nil or not vim.tbl_contains(targets, current_sln) then
            local enumerated_target = { 'Choose a target to start: ' }
            for i, v in ipairs(targets) do
              enumerated_target[i + 1] = tostring(i) .. ' - ' .. v
            end
            local choice = vim.fn.inputlist(enumerated_target)
            current_sln = targets[choice]
          end
          return current_sln
        end,
      }

      if helpers.is_loaded 'rzls.roslyn_handlers' then
        roslyn_config.config.handlers = vim.tbl_extend('error', require 'rzls.roslyn_handlers', roslyn_config.config.handlers)
      end

      require('roslyn').setup(roslyn_config)

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
          if client and client.name ~= 'roslyn' then
            return
          end

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
