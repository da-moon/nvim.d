-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- ────────────────────────────────────────────────────────────
local pluginman = require("lib.plugin-manager")
local logger = require("lib.logger")()
local msg = ""
-- ────────────────────────────────────────────────────────────
local M = {}
function M.cond()
   return vim.fn.exepath("go") ~= ""
end
function M.setup() end
function M.config()
   local to_require_map = {
      ["plenary.nvim"] = { ["plenary"] = {} },
      ["nvim-treesitter"] = { ["nvim-treesitter"] = {} },
      ["guihua.nvim"] = { ["guihua"] = {} },
      ["go.nvim"] = { ["go"] = {} },
   }
   for plugin_name, modules in pairs(to_require_map) do
      for module_name, _ in pairs(modules) do
         local plug = pluginman:load_plugin(plugin_name, module_name)
         if not plug then
            msg = string.format("module < %s > from plugin <%s> could not get loaded", module_name, plugin_name)
            -- stylua: ignore start
            if logger then logger:warn(msg)  end
            -- stylua: ignore end
         else
            to_require_map[plugin_name][module_name] = plug
         end
      end
   end

   local go = to_require_map["go.nvim"]["go"]
   assert(
      go ~= nil,
      string.format(
         "module < %s > from plugin <%s> could not get loaded  [ %s ]",
         "go",
         "go.nvim",
         debug.getinfo(1, "S").source:sub(2)
      )
   )
   go.setup({
      max_line_len = 120, -- max line length in goline format
      tag_transform = false, -- tag_transfer  check gomodifytags for details
      verbose = false, -- output loginf in messages
      lsp_cfg = false, -- true: apply go.nvim non-default gopls setup
      lsp_gofumpt = true, -- true: set default gofmt in gopls format to gofumpt
      lsp_diag_hdlr = true, -- hook lsp diag handler
      dap_debug = false, -- set to true to enable dap
      dap_debug_keymap = true, -- set keymaps for debugger
      dap_debug_gui = true, -- set to true to enable dap gui, highly recommended
      dap_debug_vt = true, -- set to true to enable dap virtual text
      -- FIXME
      -- lsp_on_attach = require "lib.lsp.on_attach",
   })
end
return M
