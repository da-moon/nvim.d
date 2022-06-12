-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- ────────────────────────────────────────────────────────────
-- https://github.com/danielnehrig/nvim/blob/master/lua/config/plugins/lspconfig/init.lua
-- ────────────────────────────────────────────────────────────
-- ──────────────────────────────────────────────────────────────────────
local pluginman = require("lib.plugin-manager")
local logger = require("lib.logger")()
local msg = ""
local api = vim.api
local fn = vim.fn
local lsp = vim.lsp
local trim = vim.trim
-- ────────────────────────────────────────────────────────────
-- local packer_status, packer = pcall(require, "packer")
-- if not packer_status then
--    return print(string.format("[ %s ] : packer not found", debug.getinfo(1, "S").source:sub(2)))
-- --    return print(string.format("[ %s ] : packer not found", debug.getinfo(1, "S").source:sub(2)))
-- end
local M = {}
M.__index = M
function M.lsp_status(client, bufnr)
   local to_require_map = {
      ["lsp-status.nvim"] = { ["lsp-status"] = {} },
   }
   for plugin_name, modules in pairs(to_require_map) do
      for module_name, _ in pairs(modules) do
         local plug = pluginman:load_plugin(plugin_name, module_name)

         if not plug then
            msg = string.format("module < %s > from plugin <%s> could not get loaded  [ %s ]", module_name, plugin_name)
            -- stylua: ignore start
            if logger then logger:warn(msg)  end
            -- stylua: ignore end
         end
         to_require_map[plugin_name][module_name] = plug
      end
   end
   local lsp_status = to_require_map["lsp-status.nvim"]["lsp-status"]
   if lsp_status then
      msg = string.format("lsp-status loaded on bufnr %s", bufnr)
      -- stylua: ignore start
      if logger then logger:debug(msg)  end
      -- stylua: ignore end
      local on_attach_status, _ = pcall(lsp_status.on_attach, client)
      if on_attach_status then
         msg = string.format("lsp-status was attached successfully on bufnr %s", bufnr)
         -- stylua: ignore start
      if logger then logger:debug(msg)  end
         -- stylua: ignore end
      else
         msg = string.format("lsp-status failed to attach on bufnr %s", bufnr)
         -- stylua: ignore start
         if logger then logger:debug(msg)  end
         -- stylua: ignore end
      end
   else
      msg = string.format("lsp-status failed to load on bufnr %s", bufnr)
      -- stylua: ignore start
      if logger then logger:error(msg)  end
      -- stylua: ignore end
   end
end
function M.lsp_signature(client, bufnr)
   local to_require_map = {
      ["lsp_signature.nvim"] = { ["lsp_signature"] = {} },
   }
   for plugin_name, modules in pairs(to_require_map) do
      for module_name, _ in pairs(modules) do
         local plug = pluginman:load_plugin(plugin_name, module_name)

         if not plug then
            msg = string.format("module < %s > from plugin <%s> could not get loaded  [ %s ]", module_name, plugin_name)
            -- stylua: ignore start
            if logger then logger:warn(msg)  end
            -- stylua: ignore end
         end
         to_require_map[plugin_name][module_name] = plug
      end
   end
   local lsp_signature = to_require_map["lsp_signature.nvim"]["lsp_signature"]

   if not lsp_signature then
      msg = string.format("lsp_signature failed to load on bufnr %s", bufnr)
      -- stylua: ignore start
      if logger then logger:error(msg)  end
      -- stylua: ignore end
   else
      local on_attach_status, _ = pcall(lsp_signature.on_attach, {
         bind = true, -- This is mandatory, otherwise border config won't get registered.
         -- If you want to hook lspsaga or other signature handler, pls set to false
         doc_lines = 6, -- will show two lines of comment/doc(if there are more than two lines in doc, will be truncated);
         -- set to 0 if you DO NOT want any API comments be shown
         -- This setting only take effect in insert mode, it does not affect signature help in normal
         -- mode
         floating_window = true, -- show hint in a floating window, set to false for virtual text only mode
         hint_enable = true, -- virtual hint enable
         hint_prefix = "", -- Panda for parameter
         hint_scheme = "String",
         use_lspsaga = false, -- set to true if you want to use lspsaga popup
         hi_parameter = "FloatBorder", -- how your parameter will be highlight
         handler_opts = {
            border = "single", -- double, single, shadow, none
         },
      }, bufnr)
      if on_attach_status then
         msg = string.format("lsp_signature was attached successfully on bufnr %s", bufnr)
         -- stylua: ignore start
         if logger then logger:debug(msg)  end
         -- stylua: ignore end
      else
         msg = string.format("lsp_signature failed to attach on bufnr %s", bufnr)
         -- stylua: ignore start
         if logger then logger:error(msg)  end
         -- stylua: ignore end
      end
   end
end
function M.rename()
   local to_require_map = {
      ["plenary.nvim"] = { ["plenary.popup"] = {} },
      ["playground"] = { ["playground.hl-info"] = {} },
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
   local plenary_popup = to_require_map["plenary.nvim"]["plenary.popup"]
   local playground_hl_info = to_require_map["playground"]["playground.hl-info"]
   local rename = "textDocument/rename"
   local currName = fn.expand("<cword>")
   local tshl_status, tshl = pcall(playground_hl_info.get_treesitter_hl)
   if tshl_status then
      msg = string.format("playground.hl-info updated lsp capabilities successfully")
      -- stylua: ignore start
      if logger then logger:debug(msg)  end
      -- stylua: ignore end
   else
      msg = string.format("playground.hl-info failed to update lsp capabilities")
      -- stylua: ignore start
      if logger then logger:debug(msg)  end
      -- stylua: ignore end
   end
   if tshl and #tshl > 0 then
      local ind = tshl[#tshl]:match("^.*()%*%*.*%*%*")
      tshl = tshl[#tshl]:sub(ind + 2, -3)
   end

   local win_status, win = pcall(plenary_popup.create, currName, {
      title = "New Name",
      style = "minimal",
      borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
      relative = "cursor",
      borderhighlight = "FloatBorder",
      titlehighlight = "Title",
      highlight = tshl,
      focusable = true,
      width = 25,
      height = 1,
      line = "cursor+2",
      col = "cursor-1",
   })
   if win_status then
      msg = string.format("plenary.popup create was successful")
      -- stylua: ignore start
      if logger then logger:debug(msg)  end
      -- stylua: ignore end
   else
      msg = string.format("plenary.popup create failed")
      -- stylua: ignore start
      if logger then logger:debug(msg)  end
      -- stylua: ignore end
   end

   local function handler(err, result, ctx, config)
      if err then
         vim.notify(("Error running lsp query '%s': %s"):format(rename, err), vim.log.levels.ERROR)
      end
      local new
      if result and result.changes then
         local msg = ""
         for f, c in pairs(result.changes) do
            new = c[1].newText
            msg = msg .. ("%d changes -> %s"):format(#c, f:gsub("file://", ""):gsub(fn.getcwd(), ".")) .. "\n"
            msg = msg:sub(1, #msg - 1)
            vim.notify(msg, vim.log.levels.INFO, { title = ("Rename: %s -> %s"):format(currName, new) })
         end
      end
      lsp.handlers[rename](err, result, ctx, config)
   end

   function _G._rename(curr)
      local newName = trim(fn.getline("."))
      api.nvim_win_close(win, true)
      if #newName > 0 and newName ~= curr then
         local params = lsp.util.make_position_params()
         params.newName = newName
         lsp.buf_request(0, rename, params, handler)
      end
   end

   local map_opts = { noremap = true, silent = true }
   api.nvim_buf_set_keymap(0, "i", "<Esc>", "<cmd>stopinsert | q!<CR>", map_opts)
   api.nvim_buf_set_keymap(0, "n", "<Esc>", "<cmd>stopinsert | q!<CR>", map_opts)
   api.nvim_buf_set_keymap(0, "i", "<CR>", "<cmd>stopinsert | lua _rename('" .. currName .. "')<CR>", map_opts)
   api.nvim_buf_set_keymap(0, "n", "<CR>", "<cmd>stopinsert | lua _rename('" .. currName .. "')<CR>", map_opts)
end
return M
