-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- ────────────────────────────────────────────────────────────
local pluginman = require("lib.plugin-manager")
-- ────────────────────────────────────────────────────────────
local M = {}
function M.setup()
   vim.g.lightspeed_no_default_keymaps = true
end
function M.config()
   local module_name = "lightspeed"
   local plugin_name = "lightspeed.nvim"
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
   plug.setup({
      ignore_case = false,
      exit_after_idle_msecs = { unlabeled = 1000, labeled = nil },
      --- s/x ---
      jump_to_unique_chars = { safety_timeout = 400 },
      match_only_the_start_of_same_char_seqs = true,
      force_beacons_into_match_width = false,
      -- [ NOTE ] Display characters in a custom way in the highlighted matches.
      substitute_chars = { ["\r"] = "¬" },
      -- [ NOTE ] Leaving the appropriate list empty effectively disables "smart" mode,
      -- and forces auto-jump to be on or off.
      -- safe_labels = { . . . },
      -- labels = { },
      -- [ NOTE ] These keys are captured directly by the plugin at runtime.
      special_keys = {
         next_match_group = "<space>",
         prev_match_group = "<tab>",
      },

      --- f/t ---
      limit_ft_matches = 4,
      repeat_ft_with_target_char = false,
   })
end
return M
