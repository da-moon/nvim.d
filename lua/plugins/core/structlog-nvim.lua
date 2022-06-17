-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- fileencoding=utf-8 smartindent autoindent expandtab code: language=lua
-- insertSpaces=true tabSize=3
-- ──────────────────────────────────────────────────────────────────────

local logfile = string.format("%s/%s.log", vim.fn.stdpath("cache"), require("os").date("%Y-%m-%d"))
local M = {}
M.levels = {
   TRACE = 1,
   DEBUG = 2,
   INFO = 3,
   WARN = 4,
   ERROR = 5,
}

function M.setup()
   local fd = vim.loop.fs_open(logfile, "r", 438)
   if fd ~= nil then
      assert(vim.loop.fs_unlink(logfile), [[[ cannot
   delete file ']] .. logfile .. "'")
      assert(vim.loop.fs_close(fd), [[[ lib/file ] does_file_exists: unable to
   close ']] .. logfile .. "'")
      return true
   end
end
function M:config()
   local module_name = "structlog"
   local plugin_name = "structlog"
   local _, plug = pcall(require, plugin_name)
   assert(
      plug ~= nil,
      string.format(
         "module < %s > from plugin <%s> could not get loaded  [ %s ]",
         module_name,
         plugin_name,
         debug.getinfo(1, "S").source:sub(2)
      )
   )
   local log_level = self.levels["INFO"]
   plug.configure({
      logger = {
         sinks = {
            plug.sinks.Console(log_level, {
               async = false,
               processors = {
                  plug.processors.Namer(),
                  plug.processors.StackWriter({ "line", "file" }, { max_parents = 3, stack_level = 0 }),
                  plug.processors.Timestamper("%H:%M:%S"),
               },
               formatter = plug.formatters.FormatColorizer(
                  "%s [%-5s] %s: %-30s",
                  { "timestamp", "level", "logger_name", "msg" },
                  { level = plug.formatters.FormatColorizer.color_level() }
               ),
            }),
            plug.sinks.File(self.levels.TRACE, logfile, {
               processors = {
                  plug.processors.Namer(),
                  plug.processors.StackWriter({ "line", "file" }, { max_parents = 3, stack_level = 0 }),
                  plug.processors.Timestamper("%H:%M:%S"),
               },
               formatter = plug.formatters.Format( --
                  "%s [%-5s] %s: %-30s",
                  { "timestamp", "level", "logger_name", "msg" }
               ),
            }),
         },
      },
   })
end
return M
