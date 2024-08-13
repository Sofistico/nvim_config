return {
  {
    'kevinhwang91/nvim-ufo',
    event = 'BufAdd',
    -- opts = {
    --   provider_selector = function(bufnr, filetype, buftype)
    --     return { 'treesitter', 'indent' }
    --   end,
    -- },
    dependencies = 'kevinhwang91/promise-async',
    keys = {
      {
        'zm',
        function()
          require('ufo').closeAllFolds()
        end,
        desc = '󱃄 Close All Folds',
      },
      {
        'zr',
        function()
          require('ufo').openFoldsExceptKinds { 'comment', 'imports' }
          vim.opt.scrolloff = vim.g.baseScrolloff -- fix scrolloff setting sometimes being off
        end,
        desc = '󱃄 Open All Regular Folds',
      },
      {
        'zR',
        function()
          require('ufo').openFoldsExceptKinds {}
        end,
        desc = '󱃄 Open All Folds',
      },
      {
        'z1',
        function()
          require('ufo').closeFoldsWith(1)
        end,
        desc = '󱃄 Close L1 Folds',
      },
      {
        'z2',
        function()
          require('ufo').closeFoldsWith(2)
        end,
        desc = '󱃄 Close L2 Folds',
      },
      {
        'z3',
        function()
          require('ufo').closeFoldsWith(3)
        end,
        desc = '󱃄 Close L3 Folds',
      },
      {
        'z4',
        function()
          require('ufo').closeFoldsWith(4)
        end,
        desc = '󱃄 Close L4 Folds',
      },
    },
    opts = {
      provider_selector = function(_, ft, _)
        -- INFO some filetypes only allow indent, some only LSP, some only
        -- treesitter. However, ufo only accepts two kinds as priority,
        -- therefore making this function necessary :/
        local lspWithOutFolding = { 'markdown', 'sh', 'css', 'html', 'python', 'json' }
        if vim.tbl_contains(lspWithOutFolding, ft) then
          return { 'treesitter', 'indent' }
        end
        return { 'lsp', 'indent' }
      end,
    },
    -- keys={
    --   {'n', 'zR', }
    -- }
  },
}
