-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>xq', vim.diagnostic.setloclist, { desc = 'Open diagnostic quickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- better up and down
vim.keymap.set({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { desc = 'Down', expr = true, silent = true })
vim.keymap.set({ 'n', 'x' }, '<Down>', "v:count == 0 ? 'gj' : 'j'", { desc = 'Down', expr = true, silent = true })
vim.keymap.set({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { desc = 'Up', expr = true, silent = true })
vim.keymap.set({ 'n', 'x' }, '<Up>', "v:count == 0 ? 'gk' : 'k'", { desc = 'Up', expr = true, silent = true })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
-- vim.keymap.set('n', '<leader>-', '<C-W>s', { desc = 'Split Window Below', remap = true })
-- vim.keymap.set('n', '<leader>|', '<C-W>v', { desc = 'Split Window Right', remap = true })
-- windows
vim.keymap.set('n', '<c-w>N', '<cmd>enew<cr>', { desc = 'Create new buffer and window' })

-- Resize window using <ctrl> arrow keys
vim.keymap.set('n', '<C-Up>', '<cmd>resize +2<cr>', { desc = 'Increase Window Height' })
vim.keymap.set('n', '<C-Down>', '<cmd>resize -2<cr>', { desc = 'Decrease Window Height' })
vim.keymap.set('n', '<C-Left>', '<cmd>vertical resize -2<cr>', { desc = 'Decrease Window Width' })
vim.keymap.set('n', '<C-Right>', '<cmd>vertical resize +2<cr>', { desc = 'Increase Window Width' })

-- tabs
vim.keymap.set('n', '<leader><tab>l', '<cmd>tablast<cr>', { desc = 'Last Tab' })
vim.keymap.set('n', '<leader><tab>o', '<cmd>tabonly<cr>', { desc = 'Close Other Tabs' })
vim.keymap.set('n', '<leader><tab>f', '<cmd>tabfirst<cr>', { desc = 'First Tab' })
vim.keymap.set('n', '<leader><tab><tab>', '<cmd>tabnew<cr>', { desc = 'New Tab' })
vim.keymap.set('n', '<leader><tab>]', '<cmd>tabnext<cr>', { desc = 'Next Tab' })
vim.keymap.set('n', ']<tab>', '<cmd>tabnext<cr>', { desc = 'Next Tab' })
vim.keymap.set('n', '<leader><tab>d', '<cmd>tabclose<cr>', { desc = 'Close Tab' })
vim.keymap.set('n', '<leader><tab>[', '<cmd>tabprevious<cr>', { desc = 'Previous Tab' })
vim.keymap.set('n', '[<tab>', '<cmd>tabprevious<cr>', { desc = 'Previous Tab' })
-- vim.keymap.set('n', '<tab>', '<cmd>tabnext<cr>', {desc = "Tab Next"})
vim.keymap.set('n', '<S-tab>', '<cmd>tabnext<cr>', { desc = 'Tab Previous' })

-- quit
vim.keymap.set('n', '<leader>qq', '<cmd>conf qa<cr>', { desc = 'Quit All' })
vim.keymap.set('n', '<leader>qd', '<cmd>detach<cr>', { desc = 'Detach' })

-- buffer
vim.keymap.set('n', '<S-h>', '<cmd>bprevious<cr>', { desc = 'Prev Buffer' })
vim.keymap.set('n', '<S-l>', '<cmd>bnext<cr>', { desc = 'Next Buffer' })
vim.keymap.set('n', '[b', '<cmd>bprevious<cr>', { desc = 'Prev Buffer' })
vim.keymap.set('n', ']b', '<cmd>bnext<cr>', { desc = 'Next Buffer' })
vim.keymap.set('n', '<leader><leader>', '<cmd>e #<cr>', { desc = 'Switch to Other Buffer' })
vim.keymap.set('n', '<leader>bS', '<cmd>sp#<cr>', { desc = 'Split alternate buffer' })
vim.keymap.set('n', '<leader>bV', '<cmd>vs#<cr>', { desc = 'Vertical split alternate buffer' })
vim.keymap.set('n', '<leader>bD', '<cmd>:bd!<cr>', { desc = 'Delete Buffer and Window' })
vim.keymap.set('n', '<leader>bo', '<cmd>:%bd|e#|normal`"<cr>', { desc = 'Delete Other Buffer' })
vim.keymap.set('n', '<leader>br', '<cmd>:e!<cr>', { desc = 'Reload current buffer' })
vim.keymap.set('n', '<leader>bR', function()
  local input = vim.fn.input('File: ', '')
  vim.cmd.file(input)
end, { desc = 'Rename current buffer' })
vim.keymap.set('n', '<leader>bq', '<cmd>w|bd<cr>', { desc = 'Save and close buffer' })

-- save file
vim.keymap.set({ 'n', 'i' }, '<C-s>', '<cmd>w<cr><esc>', { desc = 'Save File' })
vim.keymap.set({ 'n', 'i' }, '<A-s>', '<cmd>wa<cr><esc>', { desc = 'Save All Files' })

-- lazy
vim.keymap.set('n', '<leader>l', '<cmd>Lazy<cr>', { desc = 'Lazy' })

-- quicktrouble
vim.keymap.set('n', '[q', vim.cmd.cprev, { desc = 'Previous Quickfix' })
vim.keymap.set('n', ']q', vim.cmd.cnext, { desc = 'Next Quickfix' })

local diagnostic_goto = function(jump, severity)
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    vim.diagnostic.jump { severity = severity, count = jump, float = true }
  end
end

vim.keymap.set('n', ']d', diagnostic_goto(1), { desc = 'Next Diagnostic' })
vim.keymap.set('n', '[d', diagnostic_goto(-1), { desc = 'Prev Diagnostic' })
vim.keymap.set('n', ']e', diagnostic_goto(1, 'ERROR'), { desc = 'Next Error' })
vim.keymap.set('n', '[e', diagnostic_goto(-1, 'ERROR'), { desc = 'Prev Error' })
vim.keymap.set('n', ']w', diagnostic_goto(1, 'WARN'), { desc = 'Next Warning' })
vim.keymap.set('n', '[w', diagnostic_goto(-1, 'WARN'), { desc = 'Prev Warning' })

-- Move Lines
vim.keymap.set('n', '<A-j>', '<cmd>m .+1<cr>==', { desc = 'Move Down' })
vim.keymap.set('n', '<A-k>', '<cmd>m .-2<cr>==', { desc = 'Move Up' })
vim.keymap.set('i', '<A-j>', '<esc><cmd>m .+1<cr>==gi', { desc = 'Move Down' })
vim.keymap.set('i', '<A-k>', '<esc><cmd>m .-2<cr>==gi', { desc = 'Move Up' })
vim.keymap.set('v', '<A-j>', ":m '>+1<cr>gv=gv", { desc = 'Move Down' })
vim.keymap.set('v', '<A-k>', ":m '<-2<cr>gv=gv", { desc = 'Move Up' })

-- vim.keymap.set('n', '<A-l>', '<cmd>><cr>', { desc = 'Move Right' })
-- vim.keymap.set('n', '<A-h>', '<cmd><<cr>', { desc = 'Move Left' })

-- code
vim.keymap.set('n', '<leader>cm', '<cmd>Mason<cr>', { desc = 'Mason' })
vim.keymap.set('n', '<leader>tS', '<cmd>lua vim.g.autoformat = not vim.g.autoformat<cr>', { desc = 'Toggle autoformat' })

vim.keymap.set('n', '<leader>cT', '<cmd>startinsert| term<cr>', { desc = 'Open Terminal in new buffer' })
vim.keymap.set('n', '<leader>ct', function()
  vim.cmd.vnew()
  vim.cmd.term()
  vim.cmd.wincmd 'J'
  vim.api.nvim_win_set_height(0, 10)
end, { desc = 'Open Terminal in Split' })

-- messagess
vim.keymap.set('n', '<leader>nH', '<cmd>messages<cr>', { desc = 'Show Nvim Messages' })

-- Signature | info
vim.keymap.set({ 'n', 'i' }, '<A-i>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', { desc = 'Show Signature' })
vim.keymap.set('i', '<C-k>', vim.lsp.buf.hover, { desc = 'Hover Info Insert' })

-- Delete words
vim.keymap.set('i', '<C-e>', '<C-o>de', { desc = 'Delete cursor after word', silent = true })

-- Tags
vim.keymap.set('n', '<M-t>', '<cmd>tag<cr>', { desc = 'Move foward tag' })

-- Remove the recording on simple q
vim.keymap.set({ 'n', 'x', 'v' }, 'q', '<nop>', {})
vim.keymap.set({ 'n', 'x', 'v' }, 'Q', 'q', { desc = 'Record macro', noremap = true })

-- remap - to nil so that oil can use it and make _ work as default _
vim.keymap.set('n', '-', '<nop>', {})
vim.keymap.set('n', '_', '-', { noremap = true, desc = 'Go back to start word' })

-- toggle relative number
vim.keymap.set('n', '<leader>tr', function()
  vim.o.relativenumber = not vim.o.relativenumber
end, { desc = 'Toggle relative number' })

-- toggle backup
vim.keymap.set('n', '<leader>tB', function()
  vim.o.writebackup = not vim.o.writebackup
  vim.notify('Write backup: ' .. tostring(vim.o.writebackup))
end, { desc = 'Toggle backup' })

if vim.fn.has 'win32' then
  vim.keymap.set('n', '<leader>tE', function()
    vim.cmd 'set fileformat=dos'
    vim.cmd 'set fenc=utf-8'
  end, { desc = 'Set fileformat to DOS' })
end
