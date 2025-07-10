return {
  'folke/persistence.nvim',
  event = 'BufReadPre',
  lazy = true,
  opts = {},
  -- stylua: ignore
  keys = {
    { "<leader>qs", function() require("persistence").load() end, desc = "Restore Session" },
    { "<leader>qS", function() require("persistence").select() end,desc = "Select Session" },
    { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
    {
      "<leader>qD",
      function()
        require("persistence").stop()
        vim.notify("Won't save current session")
      end,
      desc = "Don't Save Current Session" },
  },
}
