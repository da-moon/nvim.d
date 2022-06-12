-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- ──────────────────────────────────────────────────────────────────────
-- selene: allow(unused_variable)
-- luacheck: no unused args
return function(register)
   -- selene: deny(unused_variable)
   -- luacheck: unused args
   if not register then
      return
   end
   register({
      name = "+Files",
      ["t"] = { "<cmd>NvimTreeToggle<cr>", "Toggle File Explorer" },

      ["f"] = {
         function()
            require("telescope.builtin").find_files()
         end,
         "Find File",
      },
      ["g"] = {
         function()
            require("telescope.builtin").live_grep()
         end,
         "Live Grep (Word Search) Across All files",
      },
      ["w"] = {
         function()
            require("telescope.builtin").grep_string()
         end,
         "Searches for the string under your cursor in your current working directory",
      },
      ["r"] = {
         function()
            require("telescope.builtin").oldfiles()
         end,
         "List Recent Files",
      },
      ["c"] = {
         function()
            local conf = require("telescope.config").values
            local actions = require("telescope.actions")
            require("telescope.pickers").new({}, {
               prompt_title = "CD Dir",
               finder = require("telescope.finders").new_oneshot_job({ "fd", "-t", "d", "-H" }, {
                  cwd = vim.fn.getcwd(),
               }),
               sorter = conf.generic_sorter({}),
               previewer = conf.file_previewer({}),
               attach_mappings = function(prompt_bufnr, _)
                  actions.select_default:replace(function()
                     local selected = require("telescope.actions.state").get_selected_entry(prompt_bufnr)
                     actions.close(prompt_bufnr)
                     if selected == nil then
                        return
                     end
                     local result = vim.fn.chdir(selected.value)
                     if result == "" then
                        error("failed to cd to " .. selected.value, vim.diagnostic.severity.E)
                     end
                  end)
                  return true
               end,
            }):find()
         end,
         "Change Directory",
      },
      ["F"] = { "<cmd>NvimTreeFindFile<cr>", "focus on opened File in Explorer" },
   }, {
      mode = "n",
      prefix = "<leader>f",
      buffer = nil,
      silent = true,
      noremap = true,
      nowait = true,
   })
end
