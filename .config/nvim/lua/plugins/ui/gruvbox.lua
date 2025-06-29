-- ~/.config/nvim/lua/plugins/ui/gruvbox.lua
return {
  {
    "ellisonleao/gruvbox.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("gruvbox").setup({
        terminal_colors = true, -- add neovim terminal colors
        undercurl = true,
        underline = true,
        bold = true,
        italic = {
          strings = true,
          emphasis = true,
          comments = true,
          operators = false,
          folds = true,
        },
        strikethrough = true,
        invert_selection = false,
        invert_signs = false,
        invert_tabline = false,
        invert_intend_guides = false,
        inverse = true, -- invert background for search, diffs, statuslines and errors
        contrast = "", -- can be "hard", "soft" or empty string
        palette_overrides = {},
        overrides = {
          -- Flutter/Dart specific overrides
          ["@keyword.dart"] = { fg = "#fb4934", bold = true },
          ["@type.dart"] = { fg = "#fabd2f" },
          ["@constructor.dart"] = { fg = "#8ec07c", bold = true },
          ["@function.method.dart"] = { fg = "#83a598" },
          ["@variable.dart"] = { fg = "#ebdbb2" },
          ["@string.dart"] = { fg = "#b8bb26" },
          ["@comment.dart"] = { fg = "#928374", italic = true },

          -- Flutter widget highlighting
          FlutterWidget = { fg = "#fe8019", bold = true },
          FlutterProperty = { fg = "#8ec07c" },

          -- LSP specific overrides
          DiagnosticError = { fg = "#fb4934" },
          DiagnosticWarn = { fg = "#fabd2f" },
          DiagnosticInfo = { fg = "#83a598" },
          DiagnosticHint = { fg = "#8ec07c" },

          -- Telescope overrides for better Flutter file navigation
          TelescopeSelection = { bg = "#504945", fg = "#ebdbb2", bold = true },
          TelescopeMatching = { fg = "#fe8019", bold = true },
          TelescopePromptPrefix = { fg = "#fb4934" },

          -- Flutter outline tree
          NvimTreeFolderIcon = { fg = "#fabd2f" },
          NvimTreeOpenedFolderName = { fg = "#fabd2f", bold = true },
          NvimTreeFolderName = { fg = "#ebdbb2" },
          NvimTreeSpecialFile = { fg = "#fe8019", bold = true },

          -- Status line enhancements
          StatusLine = { bg = "#3c3836", fg = "#ebdbb2" },
          StatusLineNC = { bg = "#32302f", fg = "#928374" },
        },
        dim_inactive = false,
        transparent_mode = false,
      })

      -- Set the colorscheme
      vim.cmd.colorscheme("gruvbox")
    end,
  },

  -- Configure LazyVim to use Gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "gruvbox",
    },
  },

  -- Optional: Gruvbox for lualine status line
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts.options = opts.options or {}
      opts.options.theme = "gruvbox"

      -- Custom Flutter status in lualine
      table.insert(opts.sections.lualine_x, 1, {
        function()
          local flutter_tools = require("flutter-tools.utils")
          if flutter_tools.is_flutter_project() then
            return "󱓞 Flutter"
          end
          return ""
        end,
        color = { fg = "#83a598" },
      })

      -- Show current Flutter device
      table.insert(opts.sections.lualine_y, 1, {
        function()
          local device = vim.g.flutter_tools_decorations_device
          if device and device ~= "" then
            return "📱 " .. device
          end
          return ""
        end,
        color = { fg = "#8ec07c" },
      })
    end,
  },

  -- Optional: Buffer line theme
  {
    "akinsho/bufferline.nvim",
    opts = function(_, opts)
      opts.options = opts.options or {}
      opts.highlights = require("gruvbox").get_configuration().palette
    end,
  },
}
