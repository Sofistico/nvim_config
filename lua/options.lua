-- [[ Setting options ]]
-- See `:help vim.opt`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

-- show title on terminal:
vim.opt.title = true

vim.opt.termguicolors = true -- True color support
-- Make line numbers default
vim.opt.number = true
-- You can also add relative line numbers, to help with jumping.
--  Experiment for yourself to see if you like it!
vim.opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'nv'
vim.opt.virtualedit = 'block' -- Allow cursor to move where there is no text in visual block mode

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
  if vim.fn.has 'wsl' == 1 then
    vim.g.clipboard = {
      name = 'WslClipboard',
      copy = {
        ['+'] = 'clip.exe',
        ['*'] = 'clip.exe',
      },
      paste = {
        ['+'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
        ['*'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
      },
      cache_enabled = 0,
    }
  else
    vim.opt.clipboard = vim.env.SSH_TTY and '' or 'unnamedplus' -- Sync with system clipboard
  end
end)

-- indenting
vim.opt.smartindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.spelllang = { 'en' }
vim.opt.splitbelow = true -- Put new windows below current
vim.opt.splitkeep = 'cursor'
vim.opt.splitright = true -- Put new windows right of current

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
vim.opt.timeoutlen = 250

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

vim.o.foldcolumn = '0' -- '0' is not bad
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true

vim.g.root_spec = { 'lsp', { '.git', 'lua' }, 'cwd' }
vim.g.lazygit_config = true
vim.g.lazyvim_statuscolumn = {
  folds_open = false, -- show fold sign when fold is open
  folds_githl = false, -- highlight fold sign with git sign color
}

vim.opt.fillchars = {
  foldopen = '',
  foldclose = '',
  fold = ' ',
  foldsep = ' ',
  diff = '╱',
  eob = ' ',
}

vim.opt.sessionoptions = { 'buffers', 'curdir', 'tabpages', 'skiprtp', 'folds' }

vim.g.bigfile_size = 1024 * 1024 * 1.5 -- 1.5 MB

if vim.fn.has 'win32' == 1 then
  vim.cmd 'language en_US'
end

vim.g.autoformat = false

vim.o.tabstop = 2 -- A TAB character looks like 4 spaces
vim.o.expandtab = true -- Pressing the TAB key will insert spaces instead of a TAB character
vim.o.softtabstop = -1 -- Number of spaces inserted instead of a TAB character
vim.o.shiftwidth = 2 -- Number of spaces inserted when indenting

-- if vim.fn.executable 'nu' == 1 then
--   vim.o.shell = 'nu'
-- end

require('util.colors').apply_custom_colors()

if vim.g.neovide then
  vim.o.guifont = 'DejaVuSansM Nerd Font Mono:h10,Symbols Nerd Font Mono:h10'
  vim.g.neovide_scale_factor = 0.7
end

-- vim.o.winborder = 'rounded'

-- vim: ts=2 sts=2 sw=2 et
