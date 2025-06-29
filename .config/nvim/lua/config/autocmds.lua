-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")


-- ~/.config/nvim/lua/config/autocmds.lua (add to existing file)

local function augroup(name)
return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end

-- Flutter/Dart specific autocommands
vim.api.nvim_create_autocmd("FileType", {
    group = augroup("flutter_dart"),
                            pattern = { "dart" },
                            callback = function()
                            -- Set Dart-specific options
                            vim.opt_local.tabstop = 2
                            vim.opt_local.shiftwidth = 2
                            vim.opt_local.expandtab = true
                            vim.opt_local.textwidth = 80
                            vim.opt_local.colorcolumn = "80"

                            -- Enable spell checking for comments
                            vim.opt_local.spell = true
                            vim.opt_local.spelllang = "en_us"

                            -- Set up better folding for Flutter widgets
                            vim.opt_local.foldmethod = "expr"
                            vim.opt_local.foldexpr = "nvim_treesitter#foldexpr()"
                            vim.opt_local.foldenable = false -- Don't fold by default
                            end,
})

-- Auto-save before running Flutter commands
local flutter_commands = {
    "FlutterRun",
    "FlutterRestart",
    "FlutterReload",
    "FlutterHotRestart",
}

for _, cmd in ipairs(flutter_commands) do
    vim.api.nvim_create_autocmd("User", {
        pattern = "Flutter" .. cmd:gsub("Flutter", ""),
                                callback = function()
                                vim.cmd("silent! wall") -- Save all modified buffers
                                end,
    })
    end

    -- Auto-format Dart files on save
    vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup("flutter_format"),
                                pattern = "*.dart",
                                callback = function()
                                vim.lsp.buf.format({ async = false })
                                end,
    })

    -- Auto-organize imports on save
    vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup("dart_imports"),
                                pattern = "*.dart",
                                callback = function()
                                local params = {
                                    command = "edit.organizeImports",
                                    arguments = { vim.uri_from_bufnr(0) },
                                }
                                vim.lsp.buf.execute_command(params)
                                end,
    })

    -- Highlight Flutter widget constructors
    vim.api.nvim_create_autocmd("FileType", {
        group = augroup("flutter_highlights"),
                                pattern = "dart",
                                callback = function()
                                -- Add custom highlight groups for Flutter
                                vim.api.nvim_set_hl(0, "FlutterWidget", { fg = "#42A5F5", bold = true })
                                vim.api.nvim_set_hl(0, "FlutterProperty", { fg = "#66BB6A" })
                                end,
    })

    -- Auto-detect Flutter project and setup project-specific settings
    vim.api.nvim_create_autocmd("BufEnter", {
        group = augroup("flutter_project"),
                                pattern = "*.dart",
                                callback = function()
                                local root = vim.fs.find({ "pubspec.yaml", ".git" }, { upward = true })[1]
                                if root then
                                    local pubspec_path = vim.fs.find("pubspec.yaml", { path = root, upward = true })[1]
                                    if pubspec_path then
                                        -- Check if it's a Flutter project
                                        local pubspec_content = vim.fn.readfile(pubspec_path)
                                        local is_flutter = false
                                        for _, line in ipairs(pubspec_content) do
                                            if line:match("flutter:") then
                                                is_flutter = true
                                                break
                                                end
                                                end

                                                if is_flutter then
                                                    -- Set Flutter-specific settings
                                                    vim.g.flutter_project_root = vim.fn.fnamemodify(pubspec_path, ":h")
                                                    -- Enable flutter-tools features
                                                    vim.cmd("doautocmd User FlutterProjectDetected")
                                                    end
                                                    end
                                                    end
                                                    end,
    })
