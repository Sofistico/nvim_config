return {
  {
    'Saecki/crates.nvim',
    event = { 'BufRead Cargo.toml' },
    opts = {
      completion = {
        crates = {
          enabled = true,
        },
      },
      lsp = {
        enabled = true,
        actions = true,
        completion = true,
        hover = true,
      },
    },
  },
  -- {
  --   'nvim-neotest/neotest',
  --   optional = true,
  --   opts = {
  --     adapters = {
  --       ['rustaceanvim.neotest'] = {},
  --     },
  --   },
  -- },
}
