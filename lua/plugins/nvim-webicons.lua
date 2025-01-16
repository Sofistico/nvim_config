return {
  'nvim-tree/nvim-web-devicons',
  lazy = true,
  config = function ()
    local icons = require('nvim-web-devicons')
    icons.setup()
    local cs = icons.get_icon_by_filetype('cs')
    icons.set_icon({
      csharp = cs
    })
  end
}
