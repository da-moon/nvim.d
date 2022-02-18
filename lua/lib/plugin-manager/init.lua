-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- ────────────────────────────────────────────────────────────
-- https://github.com/tigorlazuardi/nvim-lazy/blob/main/lua/plugins/bootstrap.lua
-- ────────────────────────────────────────────────────────────
local utils = require("lib.utils")
-- ────────────────────────────────────────────────────────────
local M = {
   should_sync = false,
}
---this function is called when nvim starts up. it checks to see if
--packer exists; If it does not exists, it would clone and install
--it.
---@return nil
function M:init()
   local packer_path = vim.fn.stdpath("data") .. "/site/pack/packer/opt/packer.nvim"
   if utils.is_dir(packer_path) then
      vim.cmd("packadd packer.nvim")
      pcall(require, "packer")
   end
   local present, packer = pcall(require, "packer")
   if not present then
      print("Cloning packer..")
      -- remove the dir before cloning
      vim.fn.delete(packer_path, "rf")
      vim.fn.system({
         "git",
         "clone",
         "https://github.com/wbthomason/packer.nvim",
         "--depth",
         "20",
         packer_path,
      })
      vim.cmd("packadd packer.nvim")
      present, packer = pcall(require, "packer")
      if present then
         print("Packer cloned successfully.")
      else
         error("Couldn't clone packer !\nPacker path: " .. packer_path .. "\n" .. packer)
      end
      self.should_sync = true
   end
   packer.reset()
   packer.init({
      display = {
         open_fn = function()
            return require("packer.util").float({ border = "single" })
         end,
         prompt_border = "single",
      },
      git = {
         clone_timeout = 6000, -- seconds
      },
      auto_clean = true,
      compile_on_sync = true,
      opt_default = true,
      ensure_dependencies = true,
   })
   local packer_luarocks = require("packer.luarocks")
   packer_luarocks.install_commands()
   self.packer = packer
end
return M
