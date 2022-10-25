-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- ──────────────────────────────────────────────────────────────────────
local pluginman = require("lib.plugin-manager")
-- ──────────────────────────────────────────────────────────────────────

local M = {}
-- ╭────────────────────────────────────────────────────────────────────╮
-- │                     function definition start                      │
-- ╰────────────────────────────────────────────────────────────────────╯

-- enables moving files/directories
-- ──────────────────────────────────────────────────────────────────────
-- luacheck: max line length 160
-- https://github.com/dinhmai74/dotfiles/blob/9cf3227081cedd8151720c141a1e209be59f07b8/mac/.config/nvim/lua/gon/plugin-settings/nvim-tree.lua#L17
-- https://github.com/dinhmai74/dotfiles/blob/9cf3227081cedd8151720c141a1e209be59f07b8/mac/.config/nvim/lua/gon/plugin-settings/nvim-tree.lua#L83
-- luacheck: max line length 120
-- ──────────────────────────────────────────────────────────────────────
function M.mv()
   -- ╭────────────────────────────────────────────────────────────────────╮
   -- │                 loading dependancies if not loaded                 │
   -- ╰────────────────────────────────────────────────────────────────────╯

   local to_require_map = {
      ["plenary.nvim"] = {
         ["plenary.scandir"] = {},
      },
      ["telescope.nvim"] = {
         ["telescope.pickers"] = {},
         ["telescope.finders"] = {},
         ["telescope.config"] = {},
         ["telescope.themes"] = {},
         ["telescope.actions"] = {},
         ["telescope.actions.state"] = {},
      },
      ["nvim-tree.lua"] = {
         ["nvim-tree.lib"] = {},
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

   -- ╭────────────────────────────────────────────────────────────────────╮
   -- │                        importing libraries                         │
   -- ╰────────────────────────────────────────────────────────────────────╯
   local lib = to_require_map["nvim-tree.lua"]["nvim-tree.lib"]
   local scan = to_require_map["plenary.nvim"]["plenary.scandir"]
   local pickers = to_require_map["telescope.nvim"]["telescope.pickers"]
   local finders = to_require_map["telescope.nvim"]["telescope.finders"]
   local actions = to_require_map["telescope.nvim"]["telescope.actions"]
   local action_state = to_require_map["telescope.nvim"]["telescope.actions.state"]
   local conf = to_require_map["telescope.nvim"]["telescope.config"].values
   local opts = to_require_map["telescope.nvim"]["telescope.themes"].get_dropdown({})
   -- ──────────────────────────────────────────────────────────────────────
   local node = lib.get_node_at_cursor()
   -- [ FIXME ] => broken
   local cwd = lib.Tree.cwd
   local dirs = scan.scan_dir(cwd, { only_dirs = true })
   local relative_dirs = { "./" }
   for _, dir in ipairs(dirs) do
      local relative_dir = dir:gsub(cwd, "")
      table.insert(relative_dirs, relative_dir)
   end
   pickers
      .new(opts, {
         prompt_title = "Target directory",
         finder = finders.new_table({ results = relative_dirs }),
         sorter = conf.generic_sorter(opts),
         attach_mappings = function(prompt_bufnr)
            actions.select_default:replace(function()
               actions.close(prompt_bufnr)
               local selection = action_state.get_selected_entry()
               local source_file = node.absolute_path
               local target_dir = cwd .. selection[1]
               -- local target_dir = cwd
               -- if not selection[1] == "./" then
               --    local target_dir = cwd .. selection[1]
               -- end

               if not require("lib.utils").is_dir(target_dir) then
                  vim.notify("Target is not a directory")
                  return
               end
               os.execute(string.format("mv %s %s", vim.fn.shellescape(source_file), vim.fn.shellescape(target_dir)))
               lib.refresh_tree()
               -- lib.change_dir(vim.fn.fnamemodify(target_dir, ':p:h'))
               -- lib.set_index_and_redraw(target_dir)
            end)
            return true
         end,
      })
      :find()
end
-- ╭────────────────────────────────────────────────────────────────────╮
-- │                      function definition end                       │
-- ╰────────────────────────────────────────────────────────────────────╯
return M
