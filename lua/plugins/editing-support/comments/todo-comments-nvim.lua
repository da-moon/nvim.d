-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- ──────────────────────────────────────────────────────────────────────
-- [ TODO ]
-- Ensure ripgrep is installed in `run()`
-- ──────────────────────────────────────────────────────────────────────
local pluginman = require("lib.plugin-manager")
local logger = require("lib.logger")()
local msg = ""
-- ────────────────────────────────────────────────────────────
local M = {}
function M.setup() end
function M.config()
   local to_require_map = {
      ["plenary.nvim"] = { ["plenary"] = {} },
      ["telescope.nvim"] = { ["telescope"] = {} },
      ["trouble.nvim"] = { ["trouble"] = {} },
      ["todo-comments.nvim"] = { ["todo-comments"] = {} },
   }
   for plugin_name, modules in pairs(to_require_map) do
      for module_name, _ in pairs(modules) do
         local plug = pluginman:load_plugin(plugin_name, module_name)
         if not plug then
            msg = string.format("module < %s > from plugin <%s> could not get loaded", module_name, plugin_name)
            -- stylua: ignore start
            if logger then logger:warn(msg)  end
            -- stylua: ignore end
         else
            to_require_map[plugin_name][module_name] = plug
         end
      end
   end
   local plug = to_require_map["todo-comments.nvim"]["todo-comments"]
   assert(
      plug ~= nil,
      string.format(
         "module < %s > from plugin <%s> could not get loaded  [ %s ]",
         "todo-comments",
         "todo-comments.nvim",
         debug.getinfo(1, "S").source:sub(2)
      )
   )

   plug.setup({
      {
         signs = true, --  show icons in the signs column
         sign_priority = 8, --  sign priority
         keywords = { --  keywords recognized as todo comments
            FIX = {
               icon = " ", -- icon used for the sign, and in search results
               color = "error", -- can be a hex color, or a named color (see below)
               -- luacheck: max line length 160
               alt = { "FIXME", "[FIXME]", "[ FIXME ]", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
               -- luacheck: max line length 120
               -- signs = false, -- configure signs for some keywords individually
            },
            TODO = { icon = " ", color = "info", alt = { "[TODO]", "[ TODO ]" } },
            HACK = { icon = " ", color = "warning", alt = { "[HACK]", "[ HACK ]" } },
            WARN = { icon = " ", color = "warning", alt = { "WARNING", "[WARNING]", "[ WARNING ]", "XXX" } },
            PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE", "[PERF]", "[ PERF ]" } },
            NOTE = { icon = " ", color = "hint", alt = { "INFO", "[NOTE]", "[ NOTE ]" } },
         },
         merge_keywords = true, -- when true, custom keywords will be merged with the defaults
         -- highlighting of the line containing the todo comment
         -- * before: highlights before the keyword (typically comment characters)
         -- * keyword: highlights of the keyword
         -- * after: highlights after the keyword (todo text)
         highlight = {
            before = "", -- "fg" or "bg" or empty
            -- luacheck: max line length 160
            keyword = "wide", -- "fg", "bg", "wide" or empty. (wide is the same as bg, but will also highlight surrounding characters)
            -- luacheck: max line length 120
            after = "fg", -- "fg" or "bg" or empty
            pattern = [[.*<(KEYWORDS)\s*:]], -- pattern or table of patterns, used for highlightng (vim regex)
            comments_only = true, -- uses treesitter to match keywords in comments only
            max_line_len = 400, -- ignore lines longer than this
            exclude = {}, -- list of file types to exclude highlighting
         },
         -- list of named colors where we try to extract the guifg from the
         -- list of hilight groups or use the hex color if hl not found as a fallback
         colors = {
            error = { "DiagnosticError", "ErrorMsg", "#DC2626" },
            warning = { "DiagnosticWarning", "WarningMsg", "#FBBF24" },
            info = { "DiagnosticInfo", "#2563EB" },
            hint = { "DiagnosticHint", "#10B981" },
            default = { "Identifier", "#7C3AED" },
         },
         search = {
            command = "rg",
            args = {
               "--color=never",
               "--no-heading",
               "--with-filename",
               "--line-number",
               "--column",
            },
            -- regex that will be used to match keywords.
            -- don't replace the (KEYWORDS) placeholder
            pattern = [[\b(KEYWORDS):]], -- ripgrep regex
         },
      },
   })
end
return M
