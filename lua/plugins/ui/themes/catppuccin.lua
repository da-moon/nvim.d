-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- ────────────────────────────────────────────────────────────
local pluginman = require("lib.plugin-manager")
local logger = require("lib.logger")()
local msg = ""
-- ────────────────────────────────────────────────────────────

local M = {}
function M.setup()
   local to_require_map = {
      ["lightspeed.nvim"] = { ["lightspeed"] = {} },
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
end
function M.config()
   local module_name = "catppuccin"
   local plugin_name = "catppuccin"
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
   if _time.hour >= 1 and _time.hour < 9 then
      -- [ FIXME ] => plugin integration
      plug.setup({
         colorscheme = "neon_latte",
         transparency = false,
         term_colors = false,
         styles = {
            comments = "italic",
            functions = "italic",
            keywords = "italic",
            strings = "NONE",
            variables = "NONE",
         },
         integrations = {
            treesitter = true,
            native_lsp = {
               enabled = true,
               virtual_text = {
                  errors = "italic",
                  hints = "italic",
                  warnings = "italic",
                  information = "italic",
               },
               underlines = {
                  errors = "underline",
                  hints = "underline",
                  warnings = "underline",
                  information = "underline",
               },
            },
            lsp_trouble = true,
            lsp_saga = true,
            gitgutter = false,
            gitsigns = true,
            telescope = true,
            nvimtree = {
               enabled = true,
               show_root = false,
            },
            which_key = true,
            indent_blankline = {
               enabled = true,
               colored_indent_levels = true,
            },
            dashboard = true,
            neogit = false,
            vim_sneak = false,
            fern = false,
            barbar = false,
            bufferline = true,
            markdown = false,
            -- [ FIXME ] this guy broke on 2022-02-24
            -- lightspeed = true,
            lightspeed = false,
            ts_rainbow = true,
            hop = true,
         },
      })
      local status_ok, lualine_conf = pcall(require, "lib.plugins.lualine-nvim")
      if status_ok then
         lualine_conf.colors = {
            none = "NONE",
            -- bg = "#2a2e36", -- nvim bg
            bg = "#222424",
            fg = "#abb2bf", -- fg color (text)
            fg_gutter = "#3b4261",
            black = "#393b44",
            gray = "#2a2e36",
            red = "#c94f6d",
            green = "#97c374",
            yellow = "#dbc074",
            blue = "#61afef",
            magenta = "#c678dd",
            cyan = "#63cdcf",
            white = "#dfdfe0",
            orange = "#F4A261",
            pink = "#D67AD2",
            black_br = "#7f8c98",
            red_br = "#e06c75",
            green_br = "#58cd8b",
            yellow_br = "#FFE37E",
            blue_br = "#84CEE4",
            magenta_br = "#B8A1E3",
            cyan_br = "#59F0FF",
            white_br = "#FDEBC3",
            orange_br = "#F6A878",
            pink_br = "#DF97DB",
            comment = "#526175",
            bg_alt = "#0e171c", -- nvim bg
            git = {
               add = "#dfdfe0",
               change = "#F6A878",
               delete = "#e06c75",
               conflict = "#FFE37E",
            },
         }
      else
         msg = "could not load 'lib.plugins.lualine-nvim' module"
      -- stylua: ignore start
      if logger then logger:warn(msg)  end
         -- stylua: ignore end
      end
      vim.cmd([[colorscheme catppuccin]])
      msg = "using 'catppuccin' color scheme"
      -- stylua: ignore start
      if logger then logger:trace(msg)  end
      -- stylua: ignore end
   end
   -- [ TODO ] update lib.plugins.lualine-nvim and set it automatically based on time
   -- Maybe do it in setup function ?
end
return M
