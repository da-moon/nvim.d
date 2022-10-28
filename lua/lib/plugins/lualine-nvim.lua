-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- ──────────────────────────────────────────────────────────────────────
local pluginman = require("lib.plugin-manager")
local logger = require("lib.logger")()
local msg = ""
-- ──────────────────────────────────────────────────────────────────────
local M = {}
local kind = require("lib.plugins.lsp-kind")
local function clock()
   return kind.icons.clock .. os.date("%H:%M")
end

local function lsp_progress()
   local messages = vim.lsp.util.get_progress_messages()
   if #messages == 0 then
      return ""
   end
   local status = {}
   for _, msg in pairs(messages) do
      table.insert(status, (msg.percentage or 0) .. "%% " .. (msg.title or ""))
   end
   -- local spinners = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
   -- local spinners = { " ", " ", " ", " ", " ", " ", " ", " ", " ", " " }
   -- local spinners = { " ", " ", " ", " ", " ", " ", " ", " ", " " }
   local spinners = {
      " ",
      " ",
      " ",
      " ",
      " ",
      " ",
      " ",
      " ",
      " ",
      " ",
      " ",
      " ",
      " ",
      " ",
      " ",
      " ",
      " ",
      " ",
      " ",
      " ",
      " ",
      " ",
      " ",
      " ",
      " ",
      " ",
      " ",
      " ",
   }
   local ms = vim.loop.hrtime() / 1000000
   local frame = math.floor(ms / 60) % #spinners
   return spinners[frame + 1] .. " " .. table.concat(status, " | ")
end

vim.cmd([[autocmd User LspProgressUpdate let &ro = &ro]])

local function diff_source()
   local gitsigns = vim.b.gitsigns_status_dict
   if gitsigns then
      return {
         added = gitsigns.added,
         modified = gitsigns.changed,
         removed = gitsigns.removed,
      }
   end
end

local function testing()
   if vim.g.testing_status == "running" then
      return " "
   end
   if vim.g.testing_status == "fail" then
      return ""
   end
   if vim.g.testing_status == "pass" then
      return " "
   end
   return nil
end
local function using_session()
   return (vim.g.using_persistence ~= nil)
end

local mode = function()
   local mod = vim.fn.mode()
   local _time = os.date("*t")
   local selector = math.floor(_time.hour / 8) + 1
   local normal_icons = {
      "  ",
      "  ",
      "  ",
   }
   if mod == "n" or mod == "no" or mod == "nov" then
      return normal_icons[selector]
   elseif mod == "i" or mod == "ic" or mod == "ix" then
      local insert_icons = {
         "  ",
         "  ",
         "  ",
      }
      return insert_icons[selector]
   elseif mod == "V" or mod == "v" or mod == "vs" or mod == "Vs" or mod == "cv" then
      local verbose_icons = {
         " 勇",
         "  ",
         "  ",
      }
      return verbose_icons[selector]
   elseif mod == "c" or mod == "ce" then
      local command_icons = {
         "  ",
         "  ",
         "  ",
      }

      return command_icons[selector]
   elseif mod == "r" or mod == "rm" or mod == "r?" or mod == "R" or mod == "Rc" or mod == "Rv" or mod == "Rv" then
      local replace_icons = {
         "  ",
         "  ",
         "  ",
      }
      return replace_icons[selector]
   end
   return normal_icons[selector]
end

local file_icon_colors = {
   Brown = "#905532",
   Aqua = "#3AFFDB",
   Blue = "#689FB6",
   DarkBlue = "#44788E",
   Purple = "#834F79",
   Red = "#AE403F",
   Beige = "#F5C06F",
   Yellow = "#F09F17",
   Orange = "#D4843E",
   DarkOrange = "#F16529",
   Pink = "#CB6F6F",
   Salmon = "#EE6E73",
   Green = "#8FAA54",
   LightGreen = "#31B53E",
   White = "#FFFFFF",
   LightBlue = "#5fd7ff",
}
--  TODOmove to dedicated module
local function get_file_info()
   return vim.fn.expand("%:t"), vim.fn.expand("%:e")
end

local function get_file_icon()
   local module_name = "nvim-web-devicons"
   local plugin_name = "nvim-web-devicons"
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
   if not plug then
      msg = "No icon plugin found. Please install 'kyazdani42/nvim-web-devicons'"
      -- stylua: ignore start
      if logger then return logger:warn(msg)  end
      -- stylua: ignore end
   end
   local f_name, f_extension = get_file_info()
   local icon = plug.get_icon(f_name, f_extension)
   if icon == nil then
      icon = kind.icons.question
   end
   return icon
end

local function get_file_icon_color()
   local module_name = "nvim-web-devicons"
   local plugin_name = "nvim-web-devicons"
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
   if not plug then
      msg = "No icon plugin found. Please install 'kyazdani42/nvim-web-devicons'"
      -- stylua: ignore start
      if logger then return logger:warn(msg)  end
      -- stylua: ignore end
   end
   local f_name, f_ext = get_file_info()
   local icon, iconhl = plug.get_icon(f_name, f_ext)
   if icon ~= nil then
      return vim.fn.synIDattr(vim.fn.hlID(iconhl), "fg")
   end
   icon = get_file_icon():match("%S+")
   for k, _ in pairs(kind.file_icons) do
      if vim.fn.index(kind.file_icons[k], icon) ~= -1 then
         return file_icon_colors[k]
      end
   end
end

M.colors = {
   bg = "#202328",
   bg_alt = "#202328",
   fg = "#bbc2cf",
   yellow = "#ECBE7B",
   cyan = "#008080",
   darkblue = "#081633",
   green = "#98be65",
   orange = "#FF8800",
   violet = "#a9a1e1",
   magenta = "#c678dd",
   blue = "#51afef",
   red = "#ec5f67",
   git = { change = "#ECBE7B", add = "#98be65", delete = "#ec5f67", conflict = "#bb7a61" },
}
M.config = function()
   -- Color table for highlights
   local mode_color = {
      n = M.colors.git.delete,
      i = M.colors.green,
      v = M.colors.yellow,
      [""] = M.colors.blue,
      V = M.colors.yellow,
      c = M.colors.cyan,
      no = M.colors.magenta,
      s = M.colors.orange,
      S = M.colors.orange,
      [""] = M.colors.orange,
      ic = M.colors.yellow,
      R = M.colors.violet,
      Rv = M.colors.violet,
      cv = M.colors.red,
      ce = M.colors.red,
      r = M.colors.cyan,
      rm = M.colors.cyan,
      ["r?"] = M.colors.cyan,
      ["!"] = M.colors.red,
      t = M.colors.red,
   }
   local conditions = {
      buffer_not_empty = function()
         return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
      end,
      hide_in_width = function()
         return vim.fn.winwidth(0) > 80
      end,
      hide_small = function()
         return vim.fn.winwidth(0) > 150
      end,
      check_git_workspace = function()
         local filepath = vim.fn.expand("%:p:h")
         local gitdir = vim.fn.finddir(".git", filepath .. ";")
         return gitdir and #gitdir > 0 and #gitdir < #filepath
      end,
   }

   -- Config
   local config = {
      options = {
         icons_enabled = true,
         -- Disable sections and component separators
         component_separators = { left = "", right = "" },
         section_separators = { left = "", right = "" },
         theme = {
            -- We are going to use lualine_c an lualine_x as left and
            -- right section. Both are highlighted by c theme .  So we
            -- are just setting default looks o statusline
            normal = { c = { fg = M.colors.fg, bg = M.colors.bg } },
            inactive = { c = { fg = M.colors.fg, bg = M.colors.bg_alt } },
         },
         disabled_filetypes = { "dashboard", "NvimTree", "Outline", "alpha" },
      },
      sections = {
         -- these are to remove the defaults
         lualine_a = {},

         lualine_b = {},
         lualine_y = {},
         lualine_z = {},
         -- These will be filled later
         lualine_c = {},
         lualine_x = {},
      },
      inactive_sections = {
         -- these are to remove the defaults
         lualine_a = {},
         lualine_v = {},
         lualine_y = {},
         lualine_z = {},
         lualine_c = {
            {
               function()
                  vim.api.nvim_command(
                     "hi! LualineModeInactive guifg=" .. mode_color[vim.fn.mode()] .. " guibg=" .. M.colors.bg_alt
                  )
                  local _time = os.date("*t")
                  local selector = math.floor(_time.hour / 8) + 1
                  local icns = {
                     "  ",
                     "  ",
                     "  ",
                  }
                  return icns[selector]
                  -- return " "
                  -- return mode()
               end,
               color = "LualineModeInactive",
               padding = { left = 1, right = 0 },
            },
            {
               "filename",
               cond = conditions.buffer_not_empty,
               color = { fg = M.colors.blue, gui = "bold" },
            },
         },
         lualine_x = {},
      },
   }

   -- Inserts a component in lualine_c at left section
   local function ins_left(component)
      table.insert(config.sections.lualine_c, component)
   end

   -- Inserts a component in lualine_x ot right section
   local function ins_right(component)
      table.insert(config.sections.lualine_x, component)
   end

   ins_left({
      function()
         vim.api.nvim_command("hi! LualineMode guifg=" .. mode_color[vim.fn.mode()] .. " guibg=" .. M.colors.bg)
         return mode()
      end,
      color = "LualineMode",
      padding = { left = 1, right = 0 },
   })
   ins_left({
      "b:gitsigns_head",
      icon = " ",
      cond = conditions.check_git_workspace,
      color = { fg = M.colors.blue },
      padding = 0,
   })

   -- FIXME

   -- ins_left {
   --    function()
   --       local utils = require "lvim.core.lualine.utils"
   --       local filename = vim.fn.expand "%"
   --       local kube_env = os.getenv "KUBECONFIG"
   --       local kube_filename = "kubectl-edit"
   --       if (vim.bo.filetype == "yaml") and (string.sub(filename, 1, kube_filename:len()) == kube_filename) then
   --          return string.format("⎈  (%s)", utils.env_cleanup(kube_env))
   --       end
   --       return ""
   --    end,
   --    color = { fg = M.colors.cyan },
   --    cond = conditions.hide_in_width,
   -- }

   ins_left({
      function()
         vim.api.nvim_command("hi! LualineFileIconColor guifg=" .. get_file_icon_color() .. " guibg=" .. M.colors.bg)
         local winnr = vim.api.nvim_win_get_number(vim.api.nvim_get_current_win())
         if winnr > 10 then
            winnr = 10
         end
         local win = kind.numbers[winnr]
         return win .. " " .. get_file_icon()
      end,
      padding = { left = 2, right = 0 },
      cond = conditions.buffer_not_empty,
      color = "LualineFileIconColor",
      gui = "bold",
   })

   ins_left({
      function()
         local fname = vim.fn.expand("%:p")
         local ftype = vim.fn.expand("%:e")
         local cwd = vim.api.nvim_call_function("getcwd", {})
         local show_name = vim.fn.expand("%:t")
         if #cwd > 0 and #ftype > 0 then
            show_name = fname:sub(#cwd + 2)
         end
         return show_name .. "%{&readonly?'  ':''}" .. "%{&modified?'  ':''}"
      end,
      cond = conditions.buffer_not_empty,
      padding = { left = 1, right = 1 },
      color = { fg = M.colors.fg, gui = "bold" },
   })

   ins_left({
      "diff",
      source = diff_source,
      symbols = { added = "  ", modified = "柳", removed = " " },
      diff_color = {
         added = { fg = M.colors.git.add },
         modified = { fg = M.colors.git.change },
         removed = { fg = M.colors.git.delete },
      },
      color = {},
      cond = nil,
   })

   -- FIXME
   -- ins_left {
   --    function()
   --       local utils = require "lvim.core.lualine.utils"
   --       if vim.bo.filetype == "python" then
   --          local venv = os.getenv "CONDA_DEFAULT_ENV"
   --          if venv then
   --             return string.format("  (%s)", utils.env_cleanup(venv))
   --          end
   --          venv = os.getenv "VIRTUAL_ENV"
   --          if venv then
   --             return string.format("  (%s)", utils.env_cleanup(venv))
   --          end
   --          return ""
   --       end
   --       return ""
   --    end,
   --    color = { fg = M.colors.green },
   --    cond = conditions.hide_in_width,
   -- }

   ins_left({
      provider = function()
         return testing()
      end,
      enabled = function()
         return testing() ~= nil
      end,
      hl = {
         fg = M.colors.fg,
      },
      left_sep = " ",
      right_sep = {
         str = " |",
         hl = { fg = M.colors.fg },
      },
   })

   ins_left({
      provider = function()
         if vim.g.using_persistence then
            return "  |"
         elseif vim.g.using_persistence == false then
            return "  |"
         end
      end,
      enabled = function()
         return using_session()
      end,
      hl = {
         fg = M.colors.fg,
      },
   })

   ins_left({
      lsp_progress,
      cond = conditions.hide_small,
   })

   -- Insert mid section. You can make any number of sections in neovim :)
   -- for lualine it's any number greater then 2
   ins_left({
      function()
         return "%="
      end,
   })

   ins_right({
      function()
         if not vim.bo.readonly or not vim.bo.modifiable then
            return ""
         end
         return "" -- """
      end,
      color = { fg = M.colors.red },
   })

   ins_right({
      "diagnostics",
      sources = { "nvim_diagnostic" },
      symbols = { error = kind.icons.error, warn = kind.icons.warn, info = kind.icons.info, hint = kind.icons.hint },
      cond = conditions.hide_in_width,
   })

   ins_right({
      function()
         if next(vim.treesitter.highlighter.active) then
            return "  "
         end
         return ""
      end,
      padding = 0,
      color = { fg = M.colors.green },
      cond = conditions.hide_in_width,
   })
   -- FIXME
   -- ins_right {
   --    function(msg)
   --       msg = msg or kind.icons.ls_inactive .. "LS Inactive"
   --       local buf_clients = vim.lsp.buf_get_clients()
   --       if next(buf_clients) == nil then
   --          if type(msg) == "boolean" or #msg == 0 then
   --             return kind.icons.ls_inactive .. "LS Inactive"
   --          end
   --          return msg
   --       end
   --       local buf_ft = vim.bo.filetype
   --       local buf_client_names = {}
   --       local trim = vim.fn.winwidth(0) < 120

   --       for _, client in pairs(buf_clients) do
   --          if client.name ~= "null-ls" then
   --             local _added_client = client.name
   --             if trim then
   --                _added_client = string.sub(client.name, 1, 4)
   --             end
   --             table.insert(buf_client_names, _added_client)
   --          end
   --       end

   --       -- add formatter
   --       local formatters = require "lvim.lsp.null-ls.formatters"
   --       local supported_formatters = {}
   --       for _, fmt in pairs(formatters.list_registered(buf_ft)) do
   --          local _added_formatter = fmt
   --          if trim then
   --             _added_formatter = string.sub(fmt, 1, 4)
   --          end
   --          table.insert(supported_formatters, _added_formatter)
   --       end
   --       vim.list_extend(buf_client_names, supported_formatters)

   --       -- add linter
   --       local linters = require "lvim.lsp.null-ls.linters"
   --       local supported_linters = {}
   --       for _, lnt in pairs(linters.list_registered(buf_ft)) do
   --          local _added_linter = lnt
   --          if trim then
   --             _added_linter = string.sub(lnt, 1, 4)
   --          end
   --          table.insert(supported_linters, _added_linter)
   --       end
   --       vim.list_extend(buf_client_names, supported_linters)

   --       return kind.icons.ls_active .. table.concat(buf_client_names, ", ")
   --    end,
   --    color = { fg = M.colors.fg },
   --    cond = conditions.hide_in_width,
   -- }

   ins_right({
      "location",
      padding = 0,
      color = { fg = M.colors.orange },
   })

   ins_right({
      function()
         local function format_file_size(file)
            local size = vim.fn.getfsize(file)
            if size <= 0 then
               return ""
            end
            local sufixes = { "b", "k", "m", "g" }
            local i = 1
            while size > 1024 do
               size = size / 1024
               i = i + 1
            end
            return string.format("%.1f%s", size, sufixes[i])
         end
         local file = vim.fn.expand("%:p")
         if string.len(file) == 0 then
            return ""
         end
         return format_file_size(file)
      end,
      cond = conditions.buffer_not_empty,
   })
   ins_right({
      "fileformat",
      fmt = string.upper,
      icons_enabled = true,
      color = { fg = M.colors.green, gui = "bold" },
      cond = conditions.hide_in_width,
   })

   ins_right({
      clock,
      cond = conditions.hide_in_width,
      color = { fg = M.colors.blue, bg = M.colors.bg },
   })

   ins_right({
      function()
         local current_line = vim.fn.line(".")
         local total_lines = vim.fn.line("$")
         local chars = { "__", "▁▁", "▂▂", "▃▃", "▄▄", "▅▅", "▆▆", "▇▇", "██" }
         local line_ratio = current_line / total_lines
         local index = math.ceil(line_ratio * #chars)
         return chars[index]
      end,
      padding = 0,
      color = { fg = M.colors.yellow, bg = M.colors.bg },
      cond = nil,
   })
   return {
      options = config.options,
      -- sections = config.sections,
      inactive_sections = config.inactive_sections,
      -- FIXME  ?
      tabline = {},
      extensions = { "nvim-tree" },
   }
end
-- Now don't forget to initialize lualine
return M
