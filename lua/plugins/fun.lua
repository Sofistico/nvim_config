return {
  {
    'tamton-aquib/duck.nvim',
    keys = {
      {
        '<leader>nh',
        function()
          require('duck').hatch()
        end,
        desc = 'Hatch duck',
      },
      {
        '<leader>na',
        function ()
          require('duck').cook_all()
        end,
        desc = 'Cook all'
      }
    },
  },
}
