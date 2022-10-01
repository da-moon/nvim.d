-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- ──────────────────────────────────────────────────────────────────────
-- [ TODO ] => https://github.com/alexzanderr/neovim-lua/blob/master/lua/nvim-telescope-settings.lua
-- ──────────────────────────────────────────────────────────────────────
local pluginman = require("lib.plugin-manager")
local logger = require("lib.logger")()
local msg = ""
-- ────────────────────────────────────────────────────────────
local to_require_map = {
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
local M = {
   ["nvim-telescope/telescope-file-browser.nvim"] = function()
      local extension_name = "file_browser"
      local ext_status, _ = pcall(telescope.load_extension, extension_name)
      if not ext_status then
         msg = string.format("< %s > Telescope extension not found!", extension_name)
         -- stylua: ignore start
         if logger then return logger:warn(msg) else return end
            -- stylua: ignore end
         end
   end,
   ["nvim-telescope/telescope-fzf-native.nvim"] = function()
      local extension_name = "fzf"
      local ext_status, _ = pcall(telescope.load_extension, extension_name)
      if not ext_status then
         msg = string.format("< %s > Telescope extension not found!", extension_name)
      -- stylua: ignore start
      if logger then return logger:warn(msg) else return end
         -- stylua: ignore end
      end
   end,
   ["nvim-telescope/telescope-ui-select.nvim"] = function()
      local extension_name = "ui-select"
      local ext_status, _ = pcall(telescope.load_extension, extension_name)
      if not ext_status then
         msg = string.format("< %s > Telescope extension not found!", extension_name)
      -- stylua: ignore start
      if logger then return logger:warn(msg) else return end
         -- stylua: ignore end
      end
   end,
   -- https://github.com/ZenLian/nvim/blob/lua/lua/modules/tools/plugins.lua
   ["nvim-telescope/telescope-frecency.nvim"] = function()
      local extension_name = "frecency"
      local ext_status, _ = pcall(telescope.load_extension, extension_name)
      if not ext_status then
         msg = string.format("< %s > Telescope extension not found!", extension_name)
      -- stylua: ignore start
      if logger then return logger:warn(msg) else return end
      -- stylua: ignore end
      end
   end,
   ["nvim-telescope/telescope-smart-history.nvim"] = function()
      local extension_name = "smart_history"
      local ext_status, _ = pcall(telescope.load_extension, extension_name)
      if not ext_status then
         msg = string.format("< %s > Telescope extension not found!", extension_name)
      -- stylua: ignore start
      if logger then return logger:warn(msg) else return end
         -- stylua: ignore end
      end
   end,
   -- [ TODO ] configure this
   -- https://github.com/nvim-telescope/telescope-media-files.nvim
   ["nvim-telescope/telescope-media-files.nvim"] = function()
      local extension_name = "media_files"
      local ext_status, _ = pcall(telescope.load_extension, extension_name)
      if not ext_status then
         msg = string.format("< %s > Telescope extension not found!", extension_name)
      -- stylua: ignore start
      if logger then return logger:warn(msg) else return end
         -- stylua: ignore end
      end
   end,
   -- lua require'telescope'.extensions.zoxide.list{}
   ["jvgrootveld/telescope-zoxide"] = function()
      local extension_name = "zoxide"
      local ext_status, _ = pcall(telescope.load_extension, extension_name)
      if not ext_status then
         msg = string.format("< %s > Telescope extension not found!", extension_name)
      -- stylua: ignore start
      if logger then return logger:warn(msg) else return end
         -- stylua: ignore end
      end
   end,
   -- [ TODO ] => add vim-rooter
   -- [ TODO ] => add keybindings
   -- https://github.com/cljoly/telescope-repo.nvim
   ["cljoly/telescope-repo.nvim"] = function()
      local extension_name = "repo"
      local ext_status, _ = pcall(telescope.load_extension, extension_name)
      if not ext_status then
         msg = string.format("< %s > Telescope extension not found!", extension_name)
      -- stylua: ignore start
      if logger then return logger:warn(msg) else return end
         -- stylua: ignore end
      end
   end,
   ["LinArcX/telescope-command-palette.nvim"] = function()
      local extension_name = "command_palette"
      local ext_status, _ = pcall(telescope.load_extension, extension_name)
      if not ext_status then
         msg = string.format("< %s > Telescope extension not found!", extension_name)
      -- stylua: ignore start
      if logger then return logger:warn(msg) else return end
         -- stylua: ignore end
      end
   end,
   -- [ TODO ] => maybe move keybindings/plug to +Application
   ["LinArcX/telescope-env.nvim"] = function()
      local extension_name = "env"
      local ext_status, _ = pcall(telescope.load_extension, extension_name)
      if not ext_status then
         msg = string.format("< %s > Telescope extension not found!", extension_name)
      -- stylua: ignore start
      if logger then return logger:warn(msg) else return end
         -- stylua: ignore end
      end
   end,
   ["nvim-telescope/telescope-hop.nvim"] = function()
      local extension_name = "hop"
      local ext_status, _ = pcall(telescope.load_extension, extension_name)
      if not ext_status then
         msg = string.format("< %s > Telescope extension not found!", extension_name)
      -- stylua: ignore start
      if logger then return logger:warn(msg) else return end
         -- stylua: ignore end
      end
   end,
   -- [ TODO ] => add keybindings ?
   ["nvim-telescope/telescope-packer.nvim"] = function()
      local extension_name = "packer"
      local ext_status, _ = pcall(telescope.load_extension, extension_name)
      if not ext_status then
         msg = string.format("< %s > Telescope extension not found!", extension_name)
      -- stylua: ignore start
      if logger then return logger:warn(msg) else return end
         -- stylua: ignore end
      end
   end,
   -- ["https://git.sr.ht/~havi/telescope-toggleterm.nvim"] = function()
   --    local extension_name = "toggleterm"
   --    local ext_status, _ = pcall(telescope.load_extension, extension_name)
   --    if not ext_status then
   --             msg = string.format("< %s > Telescope extension not found!", extension_name)
   --    -- stylua: ignore start
   --    if logger then return logger:warn(msg) else return end
   --    -- stylua: ignore end
   --    end
   -- end,
   ["xiyaowong/telescope-emoji.nvim"] = function()
      local extension_name = "emoji"
      local ext_status, _ = pcall(telescope.load_extension, extension_name)
      if not ext_status then
         msg = string.format("< %s > Telescope extension not found!", extension_name)
      -- stylua: ignore start
      if logger then return logger:warn(msg) else return end
         -- stylua: ignore end
      end
      local module_name = "telescope-emoji.nvim"
      local plugin_name = "telescope-emoji"
      local emoji = pluginman:load_plugin(plugin_name, module_name)
      assert(
         emoji ~= nil,
         string.format(
            "module < %s > from plugin <%s> could not get loaded  [ %s ]",
            module_name,
            plugin_name,
            debug.getinfo(1, "S").source:sub(2)
         )
      )
      emoji.setup({
         action = function(emoji)
            -- argument emoji is a table.
            -- {name="", value="", cagegory="", description=""}
            vim.fn.setreg("*", emoji.value)
            print([[Press p or "*p to paste this emoji]] .. emoji.value)
         end,
      })
   end,
   -- ──────────────────────────────────────────────────────────────────────
   -- lua require('telescope').extensions.telescope_makefile.telescope_makefile()
   -- ──────────────────────────────────────────────────────────────────────
   ["ptethng/telescope-makefile"] = function() end,
   ["gbrlsnchs/telescope-lsp-handlers.nvim"] = function()
      local extension_name = "lsp_handlers"
      local ext_status, _ = pcall(telescope.load_extension, extension_name)
      if not ext_status then
         msg = string.format("< %s > Telescope extension not found!", extension_name)
      -- stylua: ignore start
      if logger then return logger:warn(msg) else return end
         -- stylua: ignore end
      end
   end,
   -- [ TODO ] => add keybindings
   ["nvim-telescope/telescope-project.nvim"] = function()
      local extension_name = "project"
      local ext_status, _ = pcall(telescope.load_extension, extension_name)
      if not ext_status then
         msg = string.format("< %s > Telescope extension not found!", extension_name)
      -- stylua: ignore start
      if logger then return logger:warn(msg) else return end
         -- stylua: ignore end
      end
   end,
   ["edolphin-ydf/goimpl.nvim"] = function()
      local extension_name = "goimpl"
      local ext_status, _ = pcall(telescope.load_extension, extension_name)
      if not ext_status then
         msg = string.format("< %s > Telescope extension not found!", extension_name)
      -- stylua: ignore start
      if logger then return logger:warn(msg) else return end
         -- stylua: ignore end
      end
   end,
}
return M
-- ──────────────────────────────────────────────────────────────────────
-- use {
--    "GustavoKatel/telescope-asynctasks.nvim",
--    event = "VimEnter",
--    requires = {
--       "nvim-telescope/telescope.nvim",
--       "nvim-lua/popup.nvim",
--       "nvim-lua/plenary.nvim",
--       "skywind3000/asynctasks.vim",
--       "skywind3000/asyncrun.vim",
--    },
--    wants = {
--       "telescope.nvim",
--    },
--    after = {
--       "telescope.nvim",
--    },
--    config = function()
--       require("telescope").extensions.asynctasks.all()
--    end,
-- }
-- ──────────────────────────────────────────────────────────────────────
-- use {
--    "~/sync/sourcehut/telescope-toggleterm.nvim",
--    event = "TermOpen",
--    requires = {
--       "akinsho/nvim-toggleterm.lua",
--       "nvim-telescope/telescope.nvim",
--       "nvim-lua/popup.nvim",
--       "nvim-lua/plenary.nvim",
--    },
--    config = function()
--       require("telescope-toggleterm").setup {
--          telescope_mappings = {
--             ["<C-d>"] = require("telescope-toggleterm").actions.exit_terminal,
--          },
--       }
--       require("telescope").load_extension "toggleterm"
--    end,
-- }
-- ──────────────────────────────────────────────────────────────────────
-- ──────────────────────────────────────────────────────────────────────
-- ──────────────────────────────────────────────────────────────────────
