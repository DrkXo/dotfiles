-- ~/.config/nvim/lua/plugins/lsp/dart-lsp.lua
return {
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                dartls = {
                    cmd = { "dart", "language-server", "--protocol=lsp" },
                    filetypes = { "dart" },
                    init_options = {
                        onlyAnalyzeProjectsWithOpenFiles = false,
                        suggestFromUnimportedLibraries = true,
                        closingLabels = true,
                        outline = true,
                        flutterOutline = true,
                    },
                    settings = {
                        dart = {
                            analysisExcludedFolders = {
                                vim.fn.expand("$HOME/AppData/Local/Pub/Cache"),
                                vim.fn.expand("$HOME/.pub-cache"),
                                vim.fn.expand("/opt/homebrew/"),
                                vim.fn.expand("$HOME/tools/flutter/"),
                            },
                            updateImportsOnRename = true,
                            completeFunctionCalls = true,
                            showTodos = true,
                            enableSnippets = true,
                        }
                    },
                    on_attach = function(client, bufnr)
                    -- Dart specific configurations
                    vim.api.nvim_buf_set_option(bufnr, 'tabstop', 2)
                    vim.api.nvim_buf_set_option(bufnr, 'shiftwidth', 2)
                    vim.api.nvim_buf_set_option(bufnr, 'expandtab', true)
                    end,
                },
            },
        },
    },
}
