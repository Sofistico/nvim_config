local M = {}
M.dll = nil

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
        coroutine.resume(dap_run_co, choice)
      end
    end

    vim.ui.select(items, opts, cont)
  end)
end

return M
