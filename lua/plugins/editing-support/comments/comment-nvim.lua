-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- ────────────────────────────────────────────────────────────
local pluginman = require("lib.plugin-manager")
local logger = require("lib.logger")()
local msg = ""
-- ────────────────────────────────────────────────────────────
local M = {}

function M.setup() end
function M.config()
   local to_require_map = {
      ["Comment.nvim"] = {
         ["Comment"] = {},
         ["Comment.utils"] = {},
      },
      ["nvim-ts-context-commentstring"] = {
         ["ts_context_commentstring.utils"] = {},
         ["ts_context_commentstring.internal"] = {},
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
   local plug = to_require_map["Comment.nvim"]["Comment"]
   assert(
      plug ~= nil,
      string.format(
         "module < %s > from plugin <%s> could not get loaded  [ %s ]",
         "Comment",
         "Comment.nvim",
         debug.getinfo(1, "S").source:sub(2)
      )
   )
   -- autocmd BufEnter *.cpp,*.h :lua vim.api.nvim_buf_set_option(0, "commentstring", "// %s")
   plug.setup({
      pre_hook = function(ctx)
         -- Only calculate commentstring for tsx filetypes
         if vim.bo.filetype == "typescriptreact" then
            local U = to_require_map["Comment.nvim"]["Comment.utils"]
            -- Detemine whether to use linewise or blockwise commentstring
            local type = ctx.ctype == U.ctype.line and "__default" or "__multiline"
            -- Determine the location where to calculate commentstring from
            local location = nil
            local commentstring_utils =
               to_require_map["nvim-ts-context-commentstring"]["ts_context_commentstring.utils"]
            if not commentstring_utils then
               return
            end

            if ctx.ctype == U.ctype.block then
               location = commentstring_utils.get_cursor_location()
            elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
               location = commentstring_utils.get_visual_start_location()
            end
            local commentstring_internal =
               to_require_map["nvim-ts-context-commentstring"]["ts_context_commentstring.internal"]
            if not commentstring_internal then
               return
            end
            return commentstring_internal.calculate_commentstring({
               key = type,
               location = location,
            })
         end
      end,
      ignore = function()
         return "^$"
      end,
      mappings = {
         basic = true,
         extra = false,
         extended = false,
      },
   })
end
return M
