-- ~/.config/nvim/lua/plugins/flutter/flutter-tools.lua
return {
    {
        "akinsho/flutter-tools.nvim",
        lazy = false,
        dependencies = {
            "nvim-lua/plenary.nvim",
            "stevearc/dressing.nvim", -- optional for vim.ui.select
        },
        config = function()
        require("flutter-tools").setup({
            ui = {
                border = "rounded",
                notification_style = "nvim-notify",
            },
            decorations = {
                statusline = {
                    app_version = false,
                    device = true,
                    project_config = false,
                },
            },
            debugger = {
                enabled = true,
                run_via_dap = true,
                exception_breakpoints = {},
                register_configurations = function(paths)
                require("dap").configurations.dart = {
                    {
                        type = "dart",
                        request = "launch",
                        name = "Launch dart",
                        dartSdkPath = paths.dart_sdk,
                        flutterSdkPath = paths.flutter_sdk,
                        program = "${workspaceFolder}/lib/main.dart",
                        cwd = "${workspaceFolder}",
                    },
                    {
                        type = "flutter",
                        request = "launch",
                        name = "Launch flutter",
                        dartSdkPath = paths.dart_sdk,
                        flutterSdkPath = paths.flutter_sdk,
                        program = "${workspaceFolder}/lib/main.dart",
                        cwd = "${workspaceFolder}",
                    }
                }
                end,
            },
            flutter_path = nil, -- Let flutter-tools find flutter
            flutter_lookup_cmd = nil,
            root_patterns = { ".git", "pubspec.yaml" },
            fvm = false, -- Set to true if using FVM
            widget_guides = {
                enabled = true,
            },
            closing_tags = {
                highlight = "ErrorMsg",
                prefix = "//",
                enabled = true
            },
            dev_log = {
                enabled = true,
                notify_errors = false,
                open_cmd = "tabedit",
            },
            dev_tools = {
                autostart = false,
                auto_open_browser = false,
            },
            outline = {
                open_cmd = "30vnew",
                auto_open = false
            },
            lsp = {
                color = {
                    enabled = true,
                    background = false,
                    background_color = nil,
                    foreground = false,
                        virtual_text = true,
                        virtual_text_str = "■",
                },
                on_attach = function(client, bufnr)
                -- Custom on_attach logic for Flutter LSP
                local bufopts = { noremap = true, silent = true, buffer = bufnr }

                -- Flutter specific keymaps
                vim.keymap.set('n', '<leader>fR', '<cmd>FlutterRestart<cr>', bufopts)
                vim.keymap.set('n', '<leader>fq', '<cmd>FlutterQuit<cr>', bufopts)
                vim.keymap.set('n', '<leader>fr', '<cmd>FlutterRun<cr>', bufopts)
                vim.keymap.set('n', '<leader>fD', '<cmd>FlutterDevices<cr>', bufopts)
                vim.keymap.set('n', '<leader>fE', '<cmd>FlutterEmulators<cr>', bufopts)
                vim.keymap.set('n', '<leader>fR', '<cmd>FlutterReload<cr>', bufopts)
                vim.keymap.set('n', '<leader>fo', '<cmd>FlutterOutlineToggle<cr>', bufopts)
                vim.keymap.set('n', '<leader>ft', '<cmd>FlutterDevTools<cr>', bufopts)
                vim.keymap.set('n', '<leader>fc', '<cmd>FlutterCopyProfilerUrl<cr>', bufopts)
                end,
                capabilities = require('cmp_nvim_lsp').default_capabilities(),
                                       settings = {
                                           dart = {
                                               completeFunctionCalls = true,
                                               showTodos = true,
                                               enableSnippets = true,
                                               updateImportsOnRename = true,
                                           }
                                       }
            }
        })

        -- Flutter specific telescope extensions
        require("telescope").load_extension("flutter")
        end,
    },
}
