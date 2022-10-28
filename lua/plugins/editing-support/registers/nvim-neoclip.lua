-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- ────────────────────────────────────────────────────────────
local pluginman = require("lib.plugin-manager")
local logger = require("lib.logger")()
local msg = ""
-- ────────────────────────────────────────────────────────────
local M = {}
function M.cond()
   return not require("jit").os == "Linux" and vim.fn.executable("sqlite3") ~= 0
end
function M.run()
   vim.loop.fs_mkdir(vim.fn.stdpath("data") .. "/databases", 0755)
end
function M.setup() end
function M.config()
   local to_require_map = {
      ["nvim-neoclip"] = { ["neoclip"] = {} },
      ["telescope.nvim"] = { ["telescope"] = {} },
   }
   for plugin_name, modules in pairs(to_require_map) do
      for module_name, _ in pairs(modules) do
         local plug = pluginman:load_plugin(plugin_name, module_name)
         if not plug then
            msg = string.format("module < %s > from plugin <%s> could not get loaded", module_name, plugin_name)
               -- stylua: ignore start
               if logger then logger:warn(msg)  end
            -- stylua: ignore end
         end
         to_require_map[plugin_name][module_name] = plug
      end
   end
   local neoclip = to_require_map["nvim-neoclip"]["neoclip"]
   assert(
      neoclip ~= nil,
      string.format(
         "module < %s > from plugin <%s> could not get loaded  [ %s ]",
         "neoclip",
         "nvim-neoclip",
         debug.getinfo(1, "S").source:sub(2)
      )
   )
   local telescope = to_require_map["telescope.nvim"]["telescope"]
   assert(
      telescope ~= nil,
      string.format(
         "module < %s > from plugin <%s> could not get loaded  [ %s ]",
         "telescope",
         "telescope.nvim",
         debug.getinfo(1, "S").source:sub(2)
      )
   )

   -- NOTE> vim.fn.stdpath("data") == ~/.local/share/nvim
   vim.loop.fs_mkdir(vim.fn.stdpath("data") .. "/databases", 0755)
   local db_path = vim.fn.stdpath("data") .. "/databases/neoclip.sqlite3"

   neoclip.setup({
      history = 500, --  The max number of entries to store (default 1000).
      enable_persistent_history = true, --  If set to `true` the history is stored on `VimLeavePre` using `sqlite.lua`
      db_path = db_path, --  The path to the sqlite database to store history if `enable_persistent_history=true`. Defaults to `vim.fn.stdpath("data") .. "/databases/neoclip.sqlite3` which on my system is `~/.local/share/nvim/databases/neoclip.sqlite3`
      -- --   This function filter should return `true` (include the yanked entry) or `false` (don't include it) based on a table as the only argument, which has the following keys:
      -- --   * `event`: The event from `TextYankPost` (see `:help TextYankPost` for which keys it contains).
      -- --   * `filetype`: The filetype of the buffer where the yank happened.
      -- --   * `buffer_name`: The name of the buffer where the yank happened.
      filter = nil, --  A function to filter what entries to store (default all are stored).
      preview = true, --  Whether to show a preview (default) of the current entry or not. Useful for for example multiline yanks. When yanking the filetype is recorded in order to enable correct syntax highlighting in the preview. in order to use the dynamic title showing the type of content and number of lines you need to configure `telescope` with the `dynamic_preview_title = true` option.
      default_register = { [["]], [[+]], [[*]] }, --  What register to use by default when not specified (e.g. `Telescope neoclip`). Can be a string such as `'"'` (single register) or a table of strings such as `{'"', '+', '*'}`.
      default_register_macros = "q", --  What register to use for macros by default when not specified (e.g. `Telescope macroscope`).
      enable_macro_history = true, --  If `true` (default) any recorded macro will be saved
      content_spec_column = false, --  Can be set to `true` (default `false`) to use instead of the preview. It will only show the type and number of lines next to the first line of the entry.
      on_paste = { set_reg = false }, --  if the register should be populated when pressing the key to paste directly.
      on_replay = { set_reg = false }, --  if the register should be populated when pressing the key to replay a recorded macro.
      keys = { --  keys to use for the different pickers (`telescope` and
         --  `fzf-lua`).
         telescope = { --  normal key-syntax is supported
            i = { --  insert mode is supported
               select = "<cr>",
               paste = "<c-p>",
               paste_behind = "<c-k>",
               replay = "<c-q>",
               custom = {},
            },
            n = { --  normal mode is supported
               select = "<cr>",
               paste = "p",
               paste_behind = "P",
               replay = "q",
               custom = {},
            },
         },
         fzf = { --  only insert mode is supported and `fzf`-style key-syntax needs to be used.
            select = "default",
            paste = "ctrl-p",
            paste_behind = "ctrl-k",
            custom = {}, --  You can also use the `custom` entry to specify custom actions to take on certain key-presses
         },
      },
   })
   local extension_name = "neoclip"
   local ext_status, _ = pcall(telescope.load_extension, extension_name)
   if not ext_status then
      msg = string.format("< %s > Telescope extension not found!", extension_name)
      -- stylua: ignore start
      if logger then return logger:warn(msg) else return end
      -- stylua: ignore end
   end
end
return M
