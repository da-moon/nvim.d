-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- ──────────────────────────────────────────────────────────────────────
local packer_status, packer = pcall(require, "packer")
if not packer_status then
   return print(string.format("[ %s ] : packer not found", debug.getinfo(1, "S").source:sub(2)))
end
return function()
   -- NOTE: packer_plugins is null in a fresh install ,
   if not packer_plugins then
      return
   end
   -- init
   local structlog_ok = false
   local structlog = {}
   local logger = {}
   if packer_plugins["structlog.nvim"] and not packer_plugins["structlog.nvim"].loaded then
      packer.loader("structlog.nvim")
   end
   if not structlog_ok then
      structlog_ok, structlog = pcall(require, "structlog")
      if structlog_ok then
         logger = structlog.get_logger("logger")
      end
   end
   return logger
end
