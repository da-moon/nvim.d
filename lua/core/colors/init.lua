-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- https://github.com/kyazdani42/nvim-tree.lua/blob/master/lua/nvim-tree/colors.lua
local function get_hl_groups()
   return {
      -- WindowPicker = { gui = "bold", fg = "#ededed", bg = "#4493c8" }
      Bar = { gui = "bold", fg = "#ededed", bg = "#4493c8" },
   }
end
local function get_links()
   return {}
end
local higlight_groups = get_hl_groups()
for k, d in pairs(higlight_groups) do
   local gui = d.gui and " gui=" .. d.gui or ""
   local fg = d.fg and " guifg=" .. d.fg or ""
   local bg = d.bg and " guibg=" .. d.bg or ""
   local cmd = "hi def Foo" .. k .. gui .. fg .. bg
   -- FIXME:
   vim.api.nvim_command(cmd)
end
local links = get_links()
for k, d in pairs(links) do
   vim.api.nvim_command("hi def link Foo" .. k .. " " .. d)
end
