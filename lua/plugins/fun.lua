return {
  {
    'tamton-aquib/duck.nvim',
    keys = {
      {
        '<leader>Nd',
        function()
          require('duck').hatch()
        end,
        desc = 'Hatch duck',
      },
      {
        '<leader>Na',
        function ()
          require('duck').cook_all()
        end,
        desc = 'Cook all'
      }
    },
  },
}
