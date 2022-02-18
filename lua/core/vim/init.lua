-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- https://github.com/Dekker1/dotfiles/blob/develop/dot_config/nvim/lua/options.lua
-- https://github.com/Dartt0n/Tourmaline/blob/main/hoard/neovim/config_dir/lua/settings.lua
-- https://github.com/void-kun/dotfiles/blob/master/.config/nvim/lua/settings.lua
-- https://github.com/mitschix/nvim.files/blob/master/lua/settings.lua
-- https://github.com/nogweii/dotfiles/blob/main/config/nvim/lua/me/options.lua
-- https://github.com/birdstakes/dotfiles/blob/main/nvim/lua/config/options.lua
-- https://github.com/xiaket/etc/blob/master/nvim/lua/line-number.lua
-- sed -i 's/^print/-- print/g' lua/core/init.lua

local modules = {
   "core.vim.global",
   "core.vim.options",
   "core.vim.window-options",
   "core.vim.buffer-options",
}
for _, module in ipairs(modules) do
   local status, _ = pcall(require, module)
   if not status then
      print(module .. " not found!")
   end
end
