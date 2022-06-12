-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- ──────────────────────────────────────────────────────────────────────
local pluginman = require("lib.plugin-manager")
-- ──────────────────────────────────────────────────────────────────────
local M = {}
-- shows terraform state
-- https://github.com/nvim-telescope/telescope.nvim/wiki/Configuration-Recipes#running-external-commands
function M:terraform_state()
   local to_require_map = {
      ["telescope.nvim"] = {
         ["telescope.previewers"] = {},
         ["telescope.previewers.utils"] = {},
         ["telescope.pickers"] = {},
         ["telescope.sorters"] = {},
         ["telescope.finders"] = {},
      },
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

   -- ──────────────────────────────────────────────────────────────────────

   local previewers = to_require_map["telescope.nvim"]["telescope.previewers"]
   local previewers_utils = to_require_map["telescope.nvim"]["telescope.previewers.utils"]
   local pickers = to_require_map["telescope.nvim"]["telescope.pickers"]
   local sorters = to_require_map["telescope.nvim"]["telescope.sorters"]
   local finders = to_require_map["telescope.nvim"]["telescope.finders"]

   pickers.new({
      results_title = "Resources",
      -- Run an external command and show the results in the finder window
      finder = finders.new_oneshot_job({ "terraform", "show" }),
      sorter = sorters.get_fuzzy_file(),
      previewer = previewers.new_buffer_previewer({
         -- luacheck: no unused args
         -- luacheck: ignore 432
         -- selene: allow(unused_variable,shadowing)
         define_preview = function(self, entry, status)
            -- selene: deny(unused_variable,shadowing)
            -- luacheck: enable 432
            -- luacheck: unused args
            -- Execute another command using the highlighted entry
            return previewers_utils.job_maker({ "terraform", "state", "list", entry.value }, self.state.bufnr, {
               callback = function(bufnr, content)
                  if content ~= nil then
                     previewers_utils.regex_highlighter(bufnr, "terraform")
                  end
               end,
            })
         end,
      }),
   }):find()
end
return M
