local lsp = require 'util.self_lsp'
local helpers = require 'util.self_init'
local selected_project = nil

local function fix_namespace_code_action()
  vim.api.nvim_create_user_command('CSFixNamespace', function()
    local bufnr = vim.api.nvim_get_current_buf()

    local clients = vim.lsp.get_clients { name = 'roslyn' }
    if not clients or vim.tbl_isempty(clients) then
      vim.notify("Couldn't find client", vim.log.levels.ERROR, { title = 'Roslyn' })
      return
    end

    local client = clients[1]
    local action = {
      kind = 'quickfix',
      data = {
        CustomTags = { 'SyncNamespace' },
        TextDocument = { uri = vim.uri_from_bufnr(bufnr) },
        CodeActionPath = { 'Match Folder And Namespace: Change Namespace To Match Folder' },
        Range = {
          ['start'] = { line = 0, character = 0 },
          ['end'] = { line = 0, character = 0 },
        },
        UniqueIdentifier = 'SyncNamespace',
      },
    }

    client.request('codeAction/resolve', action, function(err, resolved_action)
      if err then
        vim.notify('Fix using directives failed ' .. err.message, vim.log.levels.ERROR, { title = 'Roslyn' })
        return
      end
      vim.lsp.util.apply_workspace_edit(resolved_action.edit, client.offset_encoding)
    end)
  end, { desc = 'Fix Namespace for File' })
end

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
      local data = vim.fn.stdpath 'data' --[[@as string]]
      local libs_path = vim.fs.joinpath(data, 'mason', 'packages', 'roslyn', 'libexec')
      ---@module 'roslyn.config'
      ---@class RoslynNvimConfig
      local roslyn_config = {
        args = {
          '--stdio',
          '--logLevel=Information',
          '--extensionLogDirectory=' .. vim.fs.dirname(vim.lsp.get_log_path()),
          '--razorSourceGenerator=' .. vim.fs.joinpath(libs_path, 'Microsoft.CodeAnalysis.Razor.Compiler.dll'),
          '--razorDesignTimePath=' .. vim.fs.joinpath(
            vim.fn.stdpath 'data' --[[@as string]],
            'mason',
            'packages',
            'rzls',
            'libexec',
            'Targets',
            'Microsoft.NET.Sdk.Razor.DesignTime.targets'
          ),
          -- '--extension=' .. vim.fs.joinpath(libs_path, "Microsoft.CodeAnalysis.CSharp.dll"),
        },
        filewatching = 'roslyn',
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
          },
        },
        broad_search = true,
        choose_target = function(targets)
          if selected_project == nil or not vim.tbl_contains(targets, selected_project) then
            local enumerated_target = { 'Choose a target to start: ' }
            for i, v in ipairs(targets) do
              enumerated_target[i + 1] = tostring(i) .. ' - ' .. v
            end
            local choice = vim.fn.inputlist(enumerated_target)
            selected_project = targets[choice]
          end
          return selected_project
        end,
      }

      if helpers.is_loaded 'rzls.roslyn_handlers' then
        roslyn_config.config.handlers = require 'rzls.roslyn_handlers'
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
      fix_namespace_code_action()
    end,
  },
}
