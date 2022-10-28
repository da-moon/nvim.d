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
---this function forcefully loads a plugin module.
--and returns it.
-- https://github.com/ray-x/go.nvim/blob/d8638ab9c84e4154493ddadea995e3be078a3e16/lua/go/utils.lua#L330
---@param name string
---@param modulename string
---@return table or nil
function M:load_plugin(name, modulename)
   assert(name ~= nil, "plugin should not empty")
   assert(self.packer ~= nil, "plugin should have been initialized")
   local logger = require("lib.logger")()
   local msg = ""
   -- stylua: ignore start
   if modulename == '' or modulename == nil then modulename = name end
   -- stylua: ignore end
   local has, plugin = pcall(require, modulename)
   if has then
      msg = string.format("module < %s > was loaded successfully", modulename)
      -- stylua: ignore start
if logger then logger:trace(msg)  end
      -- stylua: ignore end
      return plugin
   end
   if packer_plugins ~= nil then
      -- packer installed
      local loader = self.packer.loader
      if not packer_plugins[name] or not packer_plugins[name].loaded then
         msg = string.format("loading < %s > with default", name)
         -- stylua: ignore start
         if logger then logger:trace(msg) end
         -- stylua: ignore end
         local plug_path = string.format("/site/pack/packer/opt/%s", name)
         plug_path = vim.fn.stdpath("data") .. plug_path
         if utils.is_dir(plug_path) then
            vim.cmd("packadd " .. name) --
            if packer_plugins[name] ~= nil then
               msg = string.format("loading < %s > with with packer", name)
               -- stylua: ignore start
               if logger then logger:trace(msg) end
               -- stylua: ignore end
               loader(name)
            end
         else
            msg = string.format("< %s > plugin directory (%s) was not found", name, plug_path)
            -- stylua: ignore start
            if logger then logger:trace(msg) end
            -- stylua: ignore end
            -- NOTE sometimes, plugins are under
            -- ~/.local/share/nvim/site/pack/packer/start
            -- that's why this functon does not return here
         end
      end
   else
      -- TODO> log name
      msg = string.format("loading < %s > with default", name)
      -- stylua: ignore start
      if logger then logger:trace(msg) end
      -- stylua: ignore end
      vim.cmd("packadd " .. name) -- load with default
   end
   has, plugin = pcall(require, modulename)
   if not has then
      -- TODO> log name
      msg = string.format("could not load < %s > module", modulename)
      -- stylua: ignore start
      if logger then return logger:warn(msg) else return end
      -- stylua: ignore end
   end
   msg = string.format("module < %s > was loaded successfully", modulename)
   -- stylua: ignore start
   if logger then logger:trace(msg) end
   -- stylua: ignore end
   return plugin
end
return M
