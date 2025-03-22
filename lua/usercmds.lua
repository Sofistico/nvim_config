vim.api.nvim_create_user_command('LspCapabilities', function()
  local curBuf = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients { bufnr = curBuf }

  for _, client in pairs(clients) do
    if client.name ~= 'null-ls' then
      local capAsList = {}
      for key, value in pairs(client.server_capabilities) do
        if value and key:find 'Provider' then
          local capability = key:gsub('Provider$', '')
          table.insert(capAsList, '- ' .. capability)
        end
      end
      table.sort(capAsList) -- sorts alphabetically
      local msg = '# ' .. client.name .. '\n' .. table.concat(capAsList, '\n')
      vim.notify(msg, 2, {
        on_open = function(win)
          local buf = vim.api.nvim_win_get_buf(win)
          vim.api.nvim_set_option_value('filetype', 'markdown', { buf = buf })
        end,
        timeout = 14000,
      })
      vim.fn.setreg('+', 'Capabilities = ' .. vim.inspect(client.server_capabilities))
    end
  end
end, {})

vim.api.nvim_create_user_command('LspAnalyzeCodeActions', function()
  local bufnr = vim.api.nvim_get_current_buf()
  local params = vim.lsp.util.make_range_params()

  params.context = {
    triggerKind = vim.lsp.protocol.CodeActionTriggerKind.Invoked,
    diagnostics = vim.lsp.diagnostic.get_line_diagnostics(),
  }

  vim.lsp.buf_request(bufnr, 'textDocument/codeAction', params, function(error, results, context, config)
    -- results is an array of lsp.CodeAction
    vim.ui.select(results, {}, function (result)
      vim.notify(vim.inspect(result))
    end)
  end)
end, {})
