-- ~/.config/nvim/lua/plugins/extras/flutter-extras.lua
return {
    -- Better Dart syntax highlighting
    {
        "dart-lang/dart-vim-plugin",
        ft = "dart",
    },

    -- Pubspec.yaml support
    {
        "akinsho/pubspec-assist.nvim",
        dependencies = "plenary.nvim",
        cmd = {
            "PubspecAssistAddDependency",
            "PubspecAssistAddDevDependency",
            "PubspecAssistPickVersion",
        },
        config = function()
        require("pubspec_assist").setup()
        end,
    },

    -- YAML support for pubspec files
    {
        "cuducos/yaml.nvim",
        ft = { "yaml" },
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-telescope/telescope.nvim",
        },
    },

    -- Better JSON support for Flutter configs
    {
        "b0o/schemastore.nvim",
        ft = { "json", "jsonc" },
    },

    -- Git integration for Flutter projects
    {
        "tpope/vim-fugitive",
        cmd = { "Git", "G" },
    },

    -- REST client for API testing
    {
        "rest-nvim/rest.nvim",
        dependencies = { "plenary.nvim" },
        config = function()
        require("rest-nvim").setup({
            result_split_horizontal = false,
            result_split_in_place = false,
            skip_ssl_verification = false,
            encode_url = true,
            highlight = {
                enabled = true,
                timeout = 150,
            },
            result = {
                show_url = true,
                show_headers = true,
                show_http_info = true,
                show_curl_command = false,
            },
            jump_to_request = false,
            env_file = '.env',
            custom_dynamic_variables = {},
            yank_dry_run = true,
        })
        end,
        ft = "http",
    },

    -- Flutter icon support
    {
        "nvim-tree/nvim-web-devicons",
        config = function()
        require("nvim-web-devicons").setup({
            override = {
                dart = {
                    icon = "",
                    color = "#03589C",
                    name = "Dart",
                },
                flutter = {
                    icon = "",
                    color = "#02569B",
                    name = "Flutter",
                },
            },
        })
        end,
    },

    -- Enhanced terminal for Flutter commands
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        config = function()
        require("toggleterm").setup({
            size = 20,
            open_mapping = [[<c-\>]],
            hide_numbers = true,
            shade_terminals = true,
            shading_factor = 2,
            start_in_insert = true,
            insert_mappings = true,
            persist_size = true,
            direction = "float",
            close_on_exit = true,
            shell = vim.o.shell,
            float_opts = {
                border = "curved",
                winblend = 0,
                highlights = {
                    border = "Normal",
                    background = "Normal",
                },
            },
        })

        -- Flutter terminal functions
        local Terminal = require('toggleterm.terminal').Terminal
        local flutter_run = Terminal:new({
            cmd = "flutter run",
            dir = "git_dir",
            direction = "float",
            float_opts = {
                border = "double",
            },
            on_open = function(term)
            vim.cmd("startinsert!")
            vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", {noremap = true, silent = true})
            end,
            on_close = function(term)
            vim.cmd("startinsert!")
            end,
        })

        function _flutter_run_toggle()
        flutter_run:toggle()
        end

        vim.api.nvim_set_keymap("n", "<leader>fr", "<cmd>lua _flutter_run_toggle()<CR>", {noremap = true, silent = true})
        end,
    },
}
