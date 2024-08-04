return {
  {
    'nvim-neotest/neotest',
    opts = {
      status = { virtual_text = true },
      output = { open_on_run = true },
      quickfix = {
        open = function()
          require('trouble').open { mode = 'quickfix', focus = false }
        end,
      },
    },
    lazy = true,
  },
}
