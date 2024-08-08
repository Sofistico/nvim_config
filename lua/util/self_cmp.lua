--@class self_cmp
local M = {}

function M.expand(snippet)
  -- Native sessions don't support nested snippet sessions.
  -- Always use the top-level session.
  -- Otherwise, when on the first placeholder and selecting a new completion,
  -- the nested session will be used instead of the top-level session.
  -- See: https://github.com/LazyVim/LazyVim/issues/3199
  local session = vim.snippet.active() and vim.snippet._session or nil

  local ok, err = pcall(vim.snippet.expand, snippet)
  if not ok then
    local fixed = M.snippet_fix(snippet)
    ok = pcall(vim.snippet.expand, fixed)

    local msg = ok and 'Failed to parse snippet,\nbut was able to fix it automatically.' or ('Failed to parse snippet.\n' .. err)

    --     LazyVim[ok and "warn" or "error"](
    --       ([[%s
    -- ```%s
    -- %s
    -- ```]]):format(msg, vim.bo.filetype, snippet),
    --       { title = "vim.snippet" }
    --     )
    vim.notify(msg)
  end

  -- Restore top-level session when needed
  if session then
    vim.snippet._session = session
  end
end

return M
