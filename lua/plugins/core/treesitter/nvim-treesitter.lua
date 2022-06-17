-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- ────────────────────────────────────────────────────────────
-- https://github.com/ttys3/nvim-config/blob/main/lua/config/nvim-treesitter.lua
-- ──────────────────────────────────────────────────────────────────────
local pluginman = require("lib.plugin-manager")
-- ──────────────────────────────────────────────────────────────────────
local M = {}

function M.config()
   local to_require_map = {
      ["nvim-treesitter"] = {
         ["nvim-treesitter.configs"] = {},
         ["nvim-treesitter.parsers"] = {},
      },
   }
   -- loading
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
   local plug = to_require_map["nvim-treesitter"]["nvim-treesitter.configs"]
   local ft_to_parser = to_require_map["nvim-treesitter"]["nvim-treesitter.parsers"].filetype_to_parsername

   plug.setup({
      ensure_installed = { -- one of "all", "maintained" (parsers with maintainers), or a list of languages
         "query",
         "c",
         "go",
         "rust",
         "python",
         -- "lua",
         "json",
         "toml",
         "vue",
         "css",
         "html",
         "bash",
         "hcl",
      },
      highlight = { enable = true },
      context_commentstring = { enable = true },
      autopairs = { enable = true },
      indent = {
         enable = true,
         disable = { "python", "yaml" },
      },
      rainbow = { enable = false },
      playground = {
         -- [ FIXME ] => maybe this is making things break
         -- enable = true,
         enable = false,
         disable = {},
         updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
         persist_queries = false, -- Whether the query persists across vim sessions
         -- keybindings = {
         --    toggle_query_editor = "o",
         --    toggle_hl_groups = "i",
         --    toggle_injected_languages = "t",
         --    toggle_anonymous_nodes = "a",
         --    toggle_language_display = "I",
         --    focus_language = "f",
         --    unfocus_language = "F",
         --    update = "R",
         --    goto_node = "<cr>",
         --    show_help = "?",
         -- },
      },
      query_linter = {
         enable = false,
         use_virtual_text = true,
         lint_events = { "BufWrite", "CursorHold" },
      },
      -- [ FIXME ] breaks on docker-bake.hcl file
      textobjects = {
         select = {
            enable = false,
            -- enable = true,
            -- Automatically jump forward to textobj, similar to targets.vim
            lookahead = true,
            keymaps = {
               -- You can use the capture groups defined in textobjects.scm
               ["af"] = "@function.outer",
               ["if"] = "@function.inner",
               ["ac"] = "@class.outer",
               ["ic"] = "@class.inner",
            },
         },
         swap = {
            enable = false,
            swap_next = { ["<leader>a"] = "@parameter.inner" },
            swap_previous = { ["<leader>A"] = "@parameter.inner" },
         },
         move = {
            enable = false,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
               ["]]"] = "@function.outer",
               ["]m"] = "@class.outer",
            },
            goto_next_end = {
               ["]["] = "@function.outer",
               ["]M"] = "@class.outer",
            },
            goto_previous_start = {
               ["[["] = "@function.outer",
               ["[m"] = "@class.outer",
            },
            goto_previous_end = {
               ["[]"] = "@function.outer",
               ["[m"] = "@class.outer",
            },
         },
      },
      incremental_selection = {
         -- [ FIXME ] => maybe this cases things to break
         -- enable = true,
         enable = false,
         keymaps = {
            init_selection = "<CR>",
            scope_incremental = "<CR>",
            node_incremental = "<TAB>",
            node_decremental = "<S-TAB>",
         },
      },
   })
   -- [ TODO ] => run only on buffer type ?
   -- nomad
   ft_to_parser.nomad = "hcl" -- the nomad filetype will use the hcl parser and queries.
   ft_to_parser.tf = "hcl"
   ft_to_parser.terraform = "hcl"
end
return M
