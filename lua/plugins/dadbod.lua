return {
  {
    'tpope/vim-dadbod',
    dependencies = {
      'kristijanhusak/vim-dadbod-completion',
      'kristijanhusak/vim-dadbod-ui',
    },
    lazy = true,
    ft = 'sql',
    cmd = 'DB',
    config = function()
      if not vim.g.use_blink then
        local cmp = require 'cmp'
        -- Setup up vim-dadbod
        cmp.setup.filetype({ 'sql' }, {
          sources = {
            { name = 'vim-dadbod-completion' },
            { name = 'buffer' },
          },
        })
      end
    end,
  },
}
