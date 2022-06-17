-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- ──────────────────────────────────────────────────────────────────────
local pluginman = require("lib.plugin-manager")
-- ──────────────────────────────────────────────────────────────────────
local M = {}
function M.config()
   local module_name = "telescope"
   local plugin_name = "telescope.nvim"
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
   -- ────────────────────────────────────────────────────────────
   local actions = require("telescope.actions")
   -- https://github.com/isphinx/dotfile/blob/master/.config/nvim/lua/plugins/telescope.lua
   local telescope_mappings = {
      i = {
         ["<esc>"] = actions.close,
         -- ["jl"] = actions.close,
         ["<C-j>"] = actions.move_selection_next,
         ["<C-k>"] = actions.move_selection_previous,
         ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
         ["<C-c>"] = actions.delete_buffer,
         ["<CR>"] = actions.select_default + actions.center,
      },
      n = {
         ["<C-j>"] = actions.move_selection_next,
         ["<C-k>"] = actions.move_selection_previous,
         ["<C-c>"] = actions.delete_buffer,
         ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
      },
   }
   -- ────────────────────────────────────────────────────────────
   local present, trouble = pcall(require, "trouble.providers.telescope")
   if present then
      telescope_mappings["i"]["<c-t>"] = trouble.open_with_trouble
      telescope_mappings["n"] = { ["<c-t>"] = trouble.open_with_trouble }
   end
   -- ────────────────────────────────────────────────────────────
   plug.setup({
      defaults = {
         find_command = { "rg", "--no-heading", "--with-filename", "--line-number", "--column", "--smart-case" },
         mappings = telescope_mappings,
         prompt_prefix = "❯ ",
         selection_caret = "→ ",
      },
      extensions = {
         fzf = {
            fuzzy = true, -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true, -- override the file sorter
            case_mode = "smart_case", -- or "ignore_case" or "respect_case"
            -- the default case_mode is "smart_case"
         },
         -- [ TODO ] => check to see if we can move this to where the plugin is getting added
         command_palette = {
            {
               "File",
               { "entire selection (C-a)", ':call feedkeys("GVgg")' },
               { "save current file (C-s)", ":w" },
               { "save all files (C-A-s)", ":wa" },
               { "quit (C-q)", ":qa" },
               { "file browser (C-i)", ":lua require'telescope'.extensions.file_browser.file_browser()", 1 },
               { "search word (A-w)", ":lua require('telescope.builtin').live_grep()", 1 },
               { "git files (A-f)", ":lua require('telescope.builtin').git_files()", 1 },
               { "files (C-f)", ":lua require('telescope.builtin').find_files()", 1 },
            },
            {
               "Help",
               { "tips", ":help tips" },
               { "cheatsheet", ":help index" },
               { "tutorial", ":help tutor" },
               { "summary", ":help summary" },
               { "quick reference", ":help quickref" },
               { "search help(F1)", ":lua require('telescope.builtin').help_tags()", 1 },
            },
            {
               "Vim",
               { "reload vimrc", ":source $MYVIMRC" },
               { "check health", ":checkhealth" },
               { "jumps (Alt-j)", ":lua require('telescope.builtin').jumplist()" },
               { "commands", ":lua require('telescope.builtin').commands()" },
               { "command history", ":lua require('telescope.builtin').command_history()" },
               { "registers (A-e)", ":lua require('telescope.builtin').registers()" },
               { "colorshceme", ":lua require('telescope.builtin').colorscheme()", 1 },
               { "vim options", ":lua require('telescope.builtin').vim_options()" },
               { "keymaps", ":lua require('telescope.builtin').keymaps()" },
               { "buffers", ":Telescope buffers" },
               { "search history (C-h)", ":lua require('telescope.builtin').search_history()" },
               { "paste mode", ":set paste!" },
               { "cursor line", ":set cursorline!" },
               { "cursor column", ":set cursorcolumn!" },
               { "spell checker", ":set spell!" },
               { "relative number", ":set relativenumber!" },
               { "search highlighting (F12)", ":set hlsearch!" },
            },
         },
         hop = {
            -- the shown `keys` are the defaults, no need to set `keys` if defaults work for you ;)
            keys = {
               "a",
               "s",
               "d",
               "f",
               "g",
               "h",
               "j",
               "k",
               "l",
               ";",
               "q",
               "w",
               "e",
               "r",
               "t",
               "y",
               "u",
               "i",
               "o",
               "p",
               "A",
               "S",
               "D",
               "F",
               "G",
               "H",
               "J",
               "K",
               "L",
               ":",
               "Q",
               "W",
               "E",
               "R",
               "T",
               "Y",
               "U",
               "I",
               "O",
               "P",
            },
            -- Highlight groups to link to signs and lines; the below configuration refers to demo
            -- sign_hl typically only defines foreground to possibly be combined with line_hl
            sign_hl = { "WarningMsg", "Title" },
            -- optional, typically a table of two highlight groups that are alternated between
            line_hl = { "CursorLine", "Normal" },
            -- options specific to `hop_loop`
            -- true temporarily disables Telescope selection highlighting
            clear_selection_hl = false,
            -- highlight hopped to entry with telescope selection highlight
            -- note: mutually exclusive with `clear_selection_hl`
            trace_entry = true,
            -- jump to entry where hoop loop was started from
            reset_selection = true,
         },
         lsp_handlers = {
            disable = {},
            location = {
               telescope = {},
               no_results_message = "No references found",
            },
            symbol = {
               telescope = {},
               no_results_message = "No symbols found",
            },
            call_hierarchy = {
               telescope = {},
               no_results_message = "No calls found",
            },
            code_action = {
               telescope = {
                  telescope = require("telescope.themes").get_dropdown({}),
               },
               no_results_message = "No code actions available",
               prefix = "",
            },
         },
      },
   })
end
return M
