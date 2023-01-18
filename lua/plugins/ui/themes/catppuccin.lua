-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- ────────────────────────────────────────────────────────────
local pluginman = require("lib.plugin-manager")
local logger = require("lib.logger")()
local msg = ""
-- ────────────────────────────────────────────────────────────

local M = {}
function M.setup()
   vim.g.catppuccin_flavour = "frappe" -- latte, frappe, macchiato, mocha
end
function M.config()
   local to_require_map = {
      ["catppuccin"] = { ["catppuccin"] = {} },
   }
   for plugin_name, modules in pairs(to_require_map) do
      for module_name, _ in pairs(modules) do
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
         to_require_map[plugin_name][module_name] = plug
      end
   end
   local plug = to_require_map["catppuccin"]["catppuccin"]

   local _time = os.date("*t")
   if _time.hour >= 1 and _time.hour < 9 then
      -- FIXME: plugin integration
      plug.setup({
         compile_path = vim.fn.stdpath("cache") .. "/catppuccin",
         transparent_background = false,
         term_colors = false,
         dim_inactive = {
            enabled = false,
            shade = "dark",
            percentage = 0.15,
         },
         styles = {
            comments = { "italic" },
            conditionals = { "italic" },
            keywords = { "italic" },
            loops = {},
            functions = {},
            strings = {},
            variables = {},
            numbers = {},
            booleans = {},
            properties = {},
            types = {},
            operators = {},
         },
         integrations = {
            cmp = true,
            gitsigns = true,
            nvimtree = true,
            telescope = true,
            treesitter = true,
            lsp_trouble = true,
            lsp_saga = true,
            gitgutter = false,
            which_key = true,
            dashboard = true,
            neogit = false,
            vim_sneak = false,
            fern = false,
            barbar = false,
            bufferline = true,
            markdown = false,
            lightspeed = true,
            ts_rainbow = true,
            hop = true,
            native_lsp = {
               enabled = true,
               virtual_text = {
                  errors = { "italic" },
                  hints = { "italic" },
                  warnings = { "italic" },
                  information = { "italic" },
               },
               underlines = {
                  errors = { "underline" },
                  hints = { "underline" },
                  warnings = { "underline" },
                  information = { "underline" },
               },
            },
            indent_blankline = {
               enabled = true,
               colored_indent_levels = true,
            },
         },
         color_overrides = {},
         custom_highlights = {},
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
   -- TODO:update lib.plugins.lualine-nvim and set it automatically based on time
end
return M
