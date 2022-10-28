-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- ──────────────────────────────────────────────────────────────────────
local pluginman = require("lib.plugin-manager")
local logger = require("lib.logger")()
local msg = ""
-- ──────────────────────────────────────────────────────────────────────
local M = {}
function M.setup()
   local module_name = "nvim-web-devicons"
   local plugin_name = "nvim-web-devicons"
   local plug = pluginman:load_plugin(plugin_name, module_name)
   -- FIXME:
   assert(
      plug ~= nil,
      string.format(
         "module < %s > from plugin <%s> could not get loaded  [ %s ]",
         module_name,
         plugin_name,
         debug.getinfo(1, "S").source:sub(2)
      )
   )
   if not plug then
      msg = "No icon plugin found. Please install 'kyazdani42/nvim-web-devicons'"
         -- stylua: ignore start
         if logger then return logger:warn(msg)  end
      -- stylua: ignore end
   end
end
function M.config()
   local module_name = "nvim-tree"
   local plugin_name = "nvim-tree.lua"
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
   -- luacheck: max line length 160
   plug.setup({
      renderer = {
         highlight_git = true,
         special_files = { "Cargo.toml", "README.md", "Makefile", "MAKEFILE", "readme.md", "CHANGELOG.md" },
         highlight_opened_files = "all",
      },
      disable_netrw = true,
      hijack_netrw = true,
      -- NOTE: use autocmd for sake of consistency
      open_on_setup = false,
      ignore_ft_on_setup = { "dashboard" },
      update_cwd = true,
      respect_buf_cwd = true,
      -- update_to_buf_dir = {
      --    enable = true,
      --    auto_open = true,
      -- },
      diagnostics = {
         enable = true,
         icons = {
            hint = "",
            info = "",
            warning = "",
            error = "",
         },
      },
      filesystem_watchers = {
         enable = true,
         debounce_delay = 50,
      },

      git = {
         enable = true,
         ignore = true,
         timeout = 500,
      },
      update_focused_file = {
         enable = true,
         update_cwd = true,
      },
      filters = {
         dotfiles = true,
         custom = { "node_modules", "target", ".git", ".vagrant", ".cache" },
      },
      trash = {
         cmd = "trash",
         require_confirm = true,
      },
      actions = {
         open_file = {
            window_picker = {
               exclude = {
                  filetype = {
                     "packer",
                     "qf",
                     "Trouble",
                     "TelescopePrompt",
                     "Outline",
                     "dapui_scopes",
                     "dapui_breakpoints",
                     "dapui_stacks",
                     "dapui_watches",
                     "dapui_repl",
                     "dap_repl",
                  },
                  buftype = { "terminal" },
               },
            },
         },
         change_dir = {
            enable = true,
            global = false,
            restrict_above_cwd = false,
         },
      },
      view = {
         width = 30,
         hide_root_folder = false,
         side = "left",
         -- auto_resize = true,
         number = false,
         relativenumber = true,
         signcolumn = "yes",
         mappings = {
            -- custom only false will merge the list with the default mappings
            -- if true, it will only use your list to set the mappings
            custom_only = true,
            -- these are default mappings
            list = {
               { key = { "<CR>", "o", "<2-LeftMouse>" }, action = "edit" },
               { key = "<", action = "prev_sibling" },
               { key = ">", action = "next_sibling" },
               { key = "P", action = "parent_node" },
               { key = "<BS>", action = "close_node" },
               { key = "<S-CR>", action = "close_node" },
               { key = "<Tab>", action = "preview" },
               { key = "K", action = "first_sibling" },
               { key = "J", action = "last_sibling" },
               { key = "I", action = "toggle_ignored" },
               { key = "R", action = "refresh" },
               { key = "a", action = "create" },
               { key = "d", action = "remove" },
               { key = "r", action = "rename" },
               { key = "<C-r>", action = "full_rename" },
               { key = "x", action = "cut" },
               { key = "c", action = "copy" },
               { key = "p", action = "paste" },
               { key = "y", action = "copy_name" },
               { key = "Y", action = "copy_path" },
               { key = "[c", action = "prev_git_item" },
               { key = "]c", action = "next_git_item" },
               { key = "s", action = "system_open" },
               { key = "q", action = "close" },
               -- ─────────────────────────────────────────────────────────────────
               -- FIXME: CB is deprecated
               { key = "b", action = "cd" },
               { key = "w", action = "vsplit" },
               { key = "W", action = "split" },
               { key = "t", action = "tabnew" },
               { key = ".", action = "toggle_dotfiles" },
               { key = "yy", action = "copy_absolute_path" },
               { key = "C", action = "dir_up" },
               { key = "?", action = "toggle_help" },
               -- https://github.com/dinhmai74/dotfiles/blob/9cf3227081cedd8151720c141a1e209be59f07b8/mac/.config/nvim/lua/gon/plugin-settings/nvim-tree.lua#L83
               -- FIXME: CB is deprecated
               { key = "m", cb = ":lua require'lib.plugins.nvim-tree'.mv()<CR>" },
            },
         },
      },
   })
   -- luacheck: max line length 120
   vim.cmd([[hi! link NvimTreeGitDirty GitSignsChange]])
   vim.cmd([[hi! link NvimTreeGitNew GitSignsAdd]])
end
return M
