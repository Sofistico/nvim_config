return {
  {
    'nvim-flutter/flutter-tools.nvim',
    lazy = true,
    event = { 'BufEnter *.dart', 'BufAdd *.dart' },
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    config = true,
  },
}
