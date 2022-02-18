-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- ──────────────────────────────────────────────────────────────────────
-- luacheck: max line length 200
-- ──────────────────────────────────────────────────────────────────────
-- https://www.reddit.com/r/neovim/comments/opipij/guide_tips_and_tricks_to_reduce_startup_and/
-- https://github.com/tigorlazuardi/nvim-lazy
-- ──────────────────────────────────────────────────────────────────────
-- luacheck: max line length 120
local modules = {
   "core",
   "plugins",
}
for _, module in ipairs(modules) do
   local status, _ = pcall(require, module)
   if not status then
      print(module .. " not found!")
   end
end
