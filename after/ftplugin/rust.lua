-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- ────────────────────────────────────────────────────────────
local pluginman = require("lib.plugin-manager")
local lsp = require("lib.lsp")
local logger = require("lib.logger")()
local msg = ""
-- ────────────────────────────────────────────────────────────
local to_require_map = {
   ["which-key.nvim"] = { ["which-key"] = {} },
   ["rust-tools.nvim"] = {
      ["rust-tools"] = {},
      ["rust-tools.inlay_hints"] = {},
      ["rust-tools.hover_actions"] = {},
      ["rust-tools.open_cargo_toml"] = {},
      ["rust-tools.parent_module"] = {},
      ["rust-tools.runnables"] = {},
   },
}
for plugin_name, modules in pairs(to_require_map) do
   for module_name, _ in pairs(modules) do
      local plug = pluginman:load_plugin(plugin_name, module_name)
      if not plug then
         msg = string.format("module < %s > from plugin <%s> could not get loaded", module_name, plugin_name)
        -- stylua: ignore start
        if logger then logger:warn(msg)  end
         -- stylua: ignore end
      end
      to_require_map[plugin_name][module_name] = plug
   end
end
-- ────────────────────────────────────────────────────────────
local rust_tools = to_require_map["rust-tools.nvim"]["rust-tools"]
if not rust_tools then
   msg = string.format("could not load 'rust-tools'")
   -- stylua: ignore start
   if logger then return logger:warn(msg) else return end
   -- stylua: ignore end
end
vim.cmd('autocmd FileType toml lua require("cmp").setup.buffer { sources = { { name = "crates" } } }')
-- ────────────────────────────────────────────────────────────
local lsp_server_name = "rust_analyzer"
---@diagnostic disable-next-line: missing-parameter
lsp:setup(lsp_server_name)
-- ────────────────────────────────────────────────────────────
local wk = to_require_map["which-key.nvim"]["which-key"]
if not wk then
   msg = string.format("could not load 'which-key'")
   -- stylua: ignore start
   if logger then return logger:warn(msg) else return end
   -- stylua: ignore end
end
local inlay_hints = to_require_map["rust-tools.nvim"]["rust-tools.inlay_hints"]
if not inlay_hints then
   msg = string.format("could not load 'rust-tools.inlay_hints'")
   -- stylua: ignore start
   if logger then return logger:warn(msg) end
   -- stylua: ignore end
end
local hover_actions = to_require_map["rust-tools.nvim"]["rust-tools.hover_actions"]
if not hover_actions then
   msg = string.format("could not load 'rust-tools.hover_actions'")
   -- stylua: ignore start
   if logger then return logger:warn(msg) end
   -- stylua: ignore end
end
local open_cargo_toml = to_require_map["rust-tools.nvim"]["rust-tools.open_cargo_toml"]
if not open_cargo_toml then
   msg = string.format("could not load 'rust-tools.open_cargo_toml'")
   -- stylua: ignore start
   if logger then return logger:warn(msg) end
   -- stylua: ignore end
end
local parent_module = to_require_map["rust-tools.nvim"]["rust-tools.parent_module"]
if not parent_module then
   msg = string.format("could not load 'rust-tools.parent_module'")
   -- stylua: ignore start
   if logger then return logger:warn(msg) end
   -- stylua: ignore end
end
local runnables = to_require_map["rust-tools.nvim"]["rust-tools.runnables"]
if not runnables then
   msg = string.format("could not load 'rust-tools.runnables'")
   -- stylua: ignore start
   if logger then return logger:warn(msg) end
   -- stylua: ignore end
end
wk.register({
   ["h"] = {
      function()
         if inlay_hints then
            inlay_hints.toggle_inlay_hints()
         end
      end,
      "Toggle inlay hints",
   },
   ["<SPACE>"] = {
      function()
         if hover_actions then
            hover_actions.hover_actions()
            vim.lsp.buf.hover()
         end
      end,
      "Toggle hover actions",
   },
   ["c"] = {
      function()
         if open_cargo_toml then
            open_cargo_toml.open_cargo_toml()
         end
      end,
      "Open Cargo.Toml",
   },
   ["p"] = {
      function()
         if parent_module then
            parent_module.parent_module()
         end
      end,
      "Open Parent Module",
   },
   ["r"] = {
      function()
         if runnables then
            runnables.runnables()
         end
      end,
      "Runnables",
   },
}, {
   mode = "n",
   prefix = "<LocalLeader>",
   buffer = vim.api.nvim_get_current_buf(),
   noremap = true,
})
wk.register({
   ["<C-h>"] = {
      function()
         if inlay_hints then
            inlay_hints.toggle_inlay_hints()
         end
      end,
      "Toggle inlay hints",
   },
   ["<C-SPACE>"] = {
      function()
         if hover_actions then
            -- https://www.reddit.com/r/neovim/comments/uk3xmq/comment/i7n6wr6/?utm_source=share&utm_medium=web2x&context=3
            -- https://vi.stackexchange.com/questions/31422/how-to-switch-mode-from-visual-visual-line-mode-to-normal-mode-in-lua
            -- https://vi.stackexchange.com/questions/31422/how-to-switch-mode-from-visual-visual-line-mode-to-normal-mode-in-lua
            vim.cmd("stopinsert")
            hover_actions.hover_actions()
            vim.lsp.buf.hover()
         end
      end,
      "Toggle hover actions",
   },
   ["<C-c>"] = {
      function()
         if open_cargo_toml then
            open_cargo_toml.open_cargo_toml()
         end
      end,
      "Open Cargo.Toml",
   },
   ["<C-p>"] = {
      function()
         if parent_module then
            parent_module.parent_module()
         end
      end,
      "Open Parent Module",
   },
   ["<C-r>"] = {
      function()
         if runnables then
            runnables.runnables()
         end
      end,
      "Runnables",
   },
}, {
   mode = "i",
   buffer = vim.api.nvim_get_current_buf(),
   noremap = true,
})
-- auto format before saving
-- vim.api.nvim_exec([[ autocmd BufWritePre *.rs :silent! lua vim.lsp.buf.format({async = true}) ]], false)
vim.cmd('autocmd BufWritePre *.rs :silent! lua vim.lsp.buf.format({async = false})')
-- -- show/refresh diagnostics after saving
-- https://github.com/neovim/neovim/issues/13324#issuecomment-847353681
-- vim.cmd('autocmd BufWritePost *.rs lua vim.diagnostic.setloclist()')