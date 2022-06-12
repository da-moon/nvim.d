-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
local modules = {
   "core.vim",
   "core.colors",
}
for _, module in ipairs(modules) do
   local status, _ = pcall(require, module)
   if not status then
      print(module .. " not found!")
   end
end
