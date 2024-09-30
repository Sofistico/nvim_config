local default_icons = require('local-icons')

--- @type LazyConfig
local LazyOptions = {
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or default_icons,
  },
}

return LazyOptions;
