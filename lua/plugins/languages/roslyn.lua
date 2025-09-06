local lsp = require 'util.self_lsp'
local rzls_enabled = true

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
        config = true,
        enabled = rzls_enabled,
      },
    },
    init = function()
      -- we add the razor filetypes before the plugin loads
      if rzls_enabled then
        vim.filetype.add {
          extension = {
            razor = 'razor',
            cshtml = 'razor',
          },
        }
      end
    end,
    opts = function()
      local mason_registry = require 'mason-registry'

      ---@type string[]
      local cmd = {}

      local roslyn_package = mason_registry.get_package 'roslyn'
      local rzls_package = mason_registry.get_package 'rzls'
      if roslyn_package:is_installed() then
        vim.list_extend(cmd, {
          'roslyn',
          '--stdio',
          '--logLevel=Information',
          '--extensionLogDirectory=' .. vim.fs.dirname(vim.lsp.get_log_path()),
        })

        if rzls_enabled and rzls_package:is_installed() then
          local rzls_path = vim.fn.expand '$MASON/packages/rzls/libexec'
          table.insert(cmd, '--razorSourceGenerator=' .. vim.fs.joinpath(rzls_path, 'Microsoft.CodeAnalysis.Razor.Compiler.dll'))
          table.insert(cmd, '--razorDesignTimePath=' .. vim.fs.joinpath(rzls_path, 'Targets', 'Microsoft.NET.Sdk.Razor.DesignTime.targets'))
          table.insert(cmd, '--extension')
          table.insert(cmd, vim.fs.joinpath(rzls_path, 'RazorExtension', 'Microsoft.VisualStudioCode.RazorExtension.dll'))
        end
      end

      ---@module 'roslyn.config'
      ---@class RoslynNvimConfig
      local roslyn_config = {
        filewatching = 'roslyn',
        ---@diagnostic disable-next-line: missing-fields
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
            vim.g.roslyn_nvim_selected_solution = current_sln
          end
          return current_sln
        end,
      }

      vim.lsp.config('roslyn', {
        cmd = cmd,
        capabilities = {
          textDocument = {
            _vs_onAutoInsert = { dynamicRegistration = false },
          },
        },
        handlers = {
          ['textDocument/_vs_onAutoInsert'] = function(err, result, _)
            if err or not result then
              return
            end
            lsp.apply_vs_text_edit(result._vs_textEdit)
          end,
          ['workspace/_roslyn_projectNeedsRestore'] = function(_, result, ctx)
            -- FIXME: workaround for roslyn_ls bug (sends here .cs files for some reason)
            -- started around 5.0.0-1.25263.3
            local project_file_paths = vim.tbl_get(result, 'projectFilePaths') or {}
            if vim.iter(project_file_paths):any(function(path)
              return vim.endswith(path, '.cs')
            end) then
              -- remove cs files and check if empty afterwards
              -- we could simply filter it out, but empty list would mean "restore-all"
              -- and it's not what we want since csprojs will come in later requests
              project_file_paths = vim
                .iter(project_file_paths)
                :filter(function(path)
                  return not vim.endswith(path, '.cs')
                end)
                :totable()
              if vim.tbl_isempty(project_file_paths) then
                ---@type lsp.ResponseError
                return { code = 0, message = '' }
              end
            end

            local client = assert(vim.lsp.get_client_by_id(ctx.client_id))

            client:request(
              ---@diagnostic disable-next-line: param-type-mismatch
              'workspace/_roslyn_restore',
              { projectFilePaths = project_file_paths },
              function(err, response)
                if err then
                  vim.notify(err.message, vim.log.levels.ERROR, { title = 'roslyn.nvim' })
                end
                if response then
                  for _, v in ipairs(response) do
                    vim.notify(v.message, vim.log.levels.INFO, { title = 'roslyn.nvim' })
                  end
                end
              end
            )

            return vim.NIL
          end,
        },
        filetypes = { 'cs' },
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
      })

      if rzls_enabled and rzls_package:is_installed() then
        vim.lsp.config('roslyn', { handlers = require 'rzls.roslyn_handlers' })
      end

      require('roslyn').setup(roslyn_config)

      require('telescope').setup {
        defaults = {
          file_ignore_patterns = { '%__virtual.cs$', '%_cshtml.g.cs$' },
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
          if client and (client.name ~= 'roslyn' or client.name == 'roslyn_ls') then
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

          local bufnr = event.buf
          -- vs_text_edit
          vim.api.nvim_create_autocmd('InsertCharPre', {
            buffer = bufnr,
            desc = "Roslyn: Trigger an auto insert on '/'.",
            callback = function()
              local char = vim.v.char

              if char ~= '/' then
                return
              end

              local row, col = unpack(vim.api.nvim_win_get_cursor(0))
              row, col = row - 1, col + 1
              local uri = vim.uri_from_bufnr(bufnr)

              local params = {
                _vs_textDocument = { uri = uri },
                _vs_position = { line = row, character = col },
                _vs_ch = char,
                _vs_options = {
                  tabSize = vim.bo[bufnr].tabstop,
                  insertSpaces = vim.bo[bufnr].expandtab,
                },
              }

              -- NOTE: We should send textDocument/_vs_onAutoInsert request only after
              -- buffer has changed.
              vim.defer_fn(function()
                client:request(
                  ---@diagnostic disable-next-line: param-type-mismatch
                  'textDocument/_vs_onAutoInsert',
                  params,
                  function(err, result, _)
                    if err or not result then
                      return
                    end

                    local newText = string.gsub(result._vs_textEdit.newText, '\r', '')
                    vim.snippet.expand(newText)
                  end,
                  bufnr
                )
              end, 1)
            end,
          })
        end,
      })
    end,
  },
}
