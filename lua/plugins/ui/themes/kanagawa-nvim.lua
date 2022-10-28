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
   local module_name = "kanagawa"
   local plugin_name = "kanagawa.nvim"
   local plug = pluginman:load_plugin(plugin_name, module_name)
   assert(
      plug ~= nil,
      string.format(
         "module < %s > from plugin <%s> could not get loaded  [ %s ]",
         module_name,
         plugin_name,
         debug.getinfo(1, "S").source:sub(2)
      )
   )
   local _time = os.date("*t")
   if _time.hour >= 17 and _time.hour < 21 then
      plug.setup({
         undercurl = true, -- enable undercurls
         commentStyle = { italic = true },
         functionStyle = {},
         keywordStyle = { italic = true },
         statementStyle = { bold = true },
         typeStyle = {},
         variablebuiltinStyle = { italic = true },
         specialReturn = true, -- special highlight for the return keyword
         specialException = true, -- special highlight for exception handling keywords
         transparent = false,
         colors = {},
         overrides = {},
      })
      local status_ok, lualine_conf = pcall(require, "lib.plugins.lualine-nvim")
      -- TODOupdate lib.plugins.lualine-nvim and set it automatically based on time
      -- Maybe do it in setup function ?
      if status_ok then
         lualine_conf.colors = {
            bg = "#16161D",
            bg_alt = "#1F1F28",
            fg = "#DCD7BA",
            red = "#43242B",
            orange = "#FFA066",
            yellow = "#DCA561",
            blue = "#7FB4CA",
            cyan = "#658594",
            violet = "#957FB8",
            magenta = "#938AA9",
            green = "#76946A",
            git = {
               add = "#76946A",
               conflict = "#252535",
               delete = "#C34043",
               change = "#DCA561",
            },
         }
      else
         msg = "could not load 'lib.plugins.lualine-nvim' module"
         -- stylua: ignore start
         if logger then logger:warn(msg)  end
         -- stylua: ignore end
      end
      vim.cmd([[colorscheme kanagawa]])
      msg = "using 'kanagawa' color scheme"
      -- stylua: ignore start
      if logger then logger:trace(msg)  end
      -- stylua: ignore end
   end
end
return M
