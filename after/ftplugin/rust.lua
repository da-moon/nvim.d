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
      ["rust-tools.hover_range"] = {},
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
}, {
   mode = "n",
   prefix = "<LocalLeader>",
   buffer = vim.api.nvim_get_current_buf(),
   noremap = true,
})
wk.register({
  ["<C-SPACE>"] = {
     function()
      if hover_actions then
        -- https://www.reddit.com/r/neovim/comments/uk3xmq/comment/i7n6wr6/?utm_source=share&utm_medium=web2x&context=3
        -- https://vi.stackexchange.com/questions/31422/how-to-switch-mode-from-visual-visual-line-mode-to-normal-mode-in-lua
        -- https://vi.stackexchange.com/questions/31422/how-to-switch-mode-from-visual-visual-line-mode-to-normal-mode-in-lua
        vim.cmd('stopinsert')
        hover_actions.hover_actions()
        vim.lsp.buf.hover()
      end
     end,
     "Toggle hover actions",
  },
}, {
  mode = "i",
  buffer = vim.api.nvim_get_current_buf(),
  noremap = true,
})
