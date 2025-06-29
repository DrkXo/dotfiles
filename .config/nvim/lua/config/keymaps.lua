-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- ~/.config/nvim/lua/config/keymaps.lua (add to existing file)

-- Flutter Development Keymaps
local function map(mode, lhs, rhs, opts)
local keys = require("lazy.core.handler").handlers.keys
if not keys.active[keys.parse({ lhs, mode = mode }).id] then
    opts = opts or {}
    opts.silent = opts.silent ~= false
    vim.keymap.set(mode, lhs, rhs, opts)
    end
    end

    -- Flutter specific keymaps
    map("n", "<leader>fr", "<cmd>FlutterRun<cr>", { desc = "Flutter Run" })
    map("n", "<leader>fR", "<cmd>FlutterRestart<cr>", { desc = "Flutter Restart" })
    map("n", "<leader>fq", "<cmd>FlutterQuit<cr>", { desc = "Flutter Quit" })
    map("n", "<leader>fD", "<cmd>FlutterDevices<cr>", { desc = "Flutter Devices" })
    map("n", "<leader>fE", "<cmd>FlutterEmulators<cr>", { desc = "Flutter Emulators" })
    map("n", "<leader>frl", "<cmd>FlutterReload<cr>", { desc = "Flutter Hot Reload" })
    map("n", "<leader>fo", "<cmd>FlutterOutlineToggle<cr>", { desc = "Flutter Outline Toggle" })
    map("n", "<leader>ft", "<cmd>FlutterDevTools<cr>", { desc = "Flutter DevTools" })
    map("n", "<leader>fc", "<cmd>FlutterCopyProfilerUrl<cr>", { desc = "Flutter Copy Profiler URL" })
    map("n", "<leader>fs", "<cmd>FlutterSuper<cr>", { desc = "Flutter Super" })
    map("n", "<leader>fv", "<cmd>FlutterVisualDebug<cr>", { desc = "Flutter Visual Debug" })

    -- Dart specific keymaps
    map("n", "<leader>da", "<cmd>Telescope flutter commands<cr>", { desc = "Flutter Commands" })
    map("n", "<leader>dd", "<cmd>lua vim.lsp.buf.definition()<cr>", { desc = "Go to Definition" })
    map("n", "<leader>dr", "<cmd>lua vim.lsp.buf.references()<cr>", { desc = "Find References" })
    map("n", "<leader>di", "<cmd>lua vim.lsp.buf.implementation()<cr>", { desc = "Go to Implementation" })
    map("n", "<leader>dh", "<cmd>lua vim.lsp.buf.hover()<cr>", { desc = "Hover Documentation" })
    map("n", "<leader>ds", "<cmd>lua vim.lsp.buf.signature_help()<cr>", { desc = "Signature Help" })
    map("n", "<leader>dn", "<cmd>lua vim.lsp.buf.rename()<cr>", { desc = "Rename Symbol" })
    map("n", "<leader>df", "<cmd>lua vim.lsp.buf.format()<cr>", { desc = "Format Code" })

    -- Testing keymaps
    map("n", "<leader>tr", "<cmd>FlutterRun --dart-define=FLUTTER_TEST=true<cr>", { desc = "Run Tests" })
    map("n", "<leader>tc", "<cmd>!flutter test --coverage<cr>", { desc = "Run Tests with Coverage" })

    -- Pubspec keymaps
    map("n", "<leader>pu", "<cmd>!flutter pub get<cr>", { desc = "Flutter Pub Get" })
    map("n", "<leader>pg", "<cmd>!flutter pub upgrade<cr>", { desc = "Flutter Pub Upgrade" })
    map("n", "<leader>pc", "<cmd>!flutter clean<cr>", { desc = "Flutter Clean" })

    -- Build keymaps
    map("n", "<leader>ba", "<cmd>!flutter build apk<cr>", { desc = "Build APK" })
    map("n", "<leader>bi", "<cmd>!flutter build ios<cr>", { desc = "Build iOS" })
    map("n", "<leader>bw", "<cmd>!flutter build web<cr>", { desc = "Build Web" })
