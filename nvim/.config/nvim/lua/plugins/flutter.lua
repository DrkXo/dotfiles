return {
  {
    "akinsho/flutter-tools.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim",
    },
    opts = {
      widget_guides = { enabled = true },
      closing_tags = { enabled = true },
      dev_log = { enabled = true, open_cmd = "tabedit" },
    },
  },
}
