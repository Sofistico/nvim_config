local M = {}
M.dll = nil
M.tail = nil
M.proj_name = nil

function M.search_for(glob)
  return vim.fn.globpath(vim.fn.getcwd(), glob, false, false)
end

function M.select_execution(glob)
  return coroutine.create(function(dap_run_co)
    local items = vim.fn.globpath(vim.fn.getcwd(), glob, false, true)
    local opts = {
      format_item = function(path)
        return vim.fn.fnamemodify(path, ':.')
      end,
    }
    local function cont(choice)
      if choice == nil then
        return nil
      else
        M.dll = choice
        M.tail = vim.fn.fnamemodify(M.dll, ':t:r')
        M.proj_name = vim.fn.fnamemodify(M.search_for('**/' .. M.tail .. '.csproj'), ':p:h')
        coroutine.resume(dap_run_co, choice)
      end
    end

    vim.ui.select(items, opts, cont)
  end)
end

return M
