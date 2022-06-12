-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- ────────────────────────────────────────────────────────────
local pluginman = require("lib.plugin-manager")
local logger = require("lib.logger")()
local msg = ""
-- ────────────────────────────────────────────────────────────
-- https://github.com/hehelego/WhyNotMarkdown/blob/master/backup/nvim/plugin_config/which-key.lua
local to_require_map = {
   ["which-key.nvim"] = { ["which-key"] = {} },
   ["nvim-markdown"] = { ["markdown"] = {} },
   ["surround.nvim"] = { ["surround"] = {} },
}
for plugin_name, modules in pairs(to_require_map) do
   for module_name, _ in pairs(modules) do
      local plug = pluginman:load_plugin(plugin_name, module_name)
      if not plug then
         msg = string.format("module < %s > from plugin <%s> could not get loaded", module_name, plugin_name)
         -- stylua: ignore start
         if logger then logger:warn(msg) end
         -- stylua: ignore end
      end
      to_require_map[plugin_name][module_name] = plug
   end
end
local wk = to_require_map["which-key.nvim"]["which-key"]
if not wk then
   msg = string.format("could not load 'which-key'")
   -- stylua: ignore start
   if logger then return logger:warn(msg) else return end
   -- stylua: ignore end
end
local markdown = to_require_map["nvim-markdown"]["markdown"]
if not markdown then
   msg = string.format("could not load 'nvim-markdown'")
   -- stylua: ignore start
   if logger then return logger:warn(msg) else return end
   -- stylua: ignore end
end
local surround = to_require_map["surround.nvim"]["surround"]
if not surround then
   msg = string.format("could not load 'surround.nvim'")
   -- stylua: ignore start
   if logger then return logger:warn(msg) else return end
   -- stylua: ignore end
end
-- ────────────────────────────────────────────────────────────
if wk.register then
   local modes = { "n", "v" }
   for _, mode in ipairs(modes) do
      wk.register({
         ["]]"] = { "<Plug>Markdown_MoveToNextHeader", "go-to-next-header" },
         ["[["] = { "<Plug>Markdown_MoveToPreviousHeader", "go-to-previous-header" },
         ["]["] = { "<Plug>Markdown_MoveToNextSiblingHeader", "go-to-next-sibling-header" },
         ["[]"] = { "<Plug>Markdown_MoveToPreviousSiblingHeader", "go-to-previous-sibling-header" },
         ["]u"] = { "<Plug>Markdown_MoveToParentHeader", "go-to-parent-header" },
         ["]c"] = { "<Plug>Markdown_MoveToCurHeader", "go-to-current-header" },
      }, {
         prefix = "<LocalLeader>",
         mode = mode,
         silent = true,
         -- [ FIX ] => should i make it local ?
         buffer = vim.api.nvim_get_current_buf(),
      })
   end
   wk.register({
      ["<CR>"] = {
         function()
            markdown.follow_link()
         end,
         "follow-links",
      },
      ["<TAB>"] = {
         function()
            markdown.fold()
         end,
         "fold-headers-or-lists",
      },
      ["<C-c>"] = {
         function()
            markdown.toggle_checkbox()
         end,
         "toggle-checkboxes",
      },
      ["t"] = { "<cmd>InsertToc<cr>", "create-table-of-content" },
      ["P"] = { "<Plug>MarkdownPreviewToggle", "Start/Stop Markdown Preview" },
      -- ["s"] = { "<cmd>MarktextMode<cr>", "marktext-snippet-mode" },
      -- ["t"] = { "<cmd>TableMode<cr>", "marktext-table-mode" },
   }, {
      prefix = "<LocalLeader>",
      mode = "n",
      silent = true,
      -- [ FIX ] => should i make it local ?
      buffer = vim.api.nvim_get_current_buf(),
   })
   -- ─── VISUAL MODE ONLY MAPPINGS ───────────────────────────────────
   wk.register({
      ["<C-k>"] = {
         function()
            markdown.create_link()
         end,
         "create-new-links",
      },
   }, {
      prefix = "<LocalLeader>",
      mode = "v",
      silent = true,
      -- [ FIX ] => should i make it local ?
      buffer = vim.api.nvim_get_current_buf(),
   })
   -- wk.register({
   --    ["<C-b>"] = {
   --       function()
   --          -- ────────────────────────────────────────────────────────────
   --          -- https://github.com/theHamsta/nvim-treesitter/blob/a5f2970d7af947c066fb65aef2220335008242b7/lua/nvim-treesitter/incremental_selection.lua#L22-L30
   --          -- local _, csrow, cscol, _ = unpack(vim.fn.getpos("'<"))
   --          -- local _, cerow, cecol, _ = unpack(vim.fn.getpos("'>"))
   --          -- if csrow < cerow or (csrow == cerow and cscol <= cecol) then
   --          --    -- return csrow - 1, cscol - 1, cerow - 1, cecol
   --          --    print(csrow - 1, cscol - 1, cerow - 1, cecol)
   --          -- else
   --          --    print(cerow - 1, cecol - 1, csrow - 1, cscol)
   --          -- end
   --          -- ────────────────────────────────────────────────────────────
   --          -- https://github.com/ur4ltz/surround.nvim/blob/5aa951f846b001b13f8af714bf76fcd650356fa8/lua/surround/utils.lua#L142
   --          local start = vim.api.nvim_buf_get_mark(0, "<")
   --          local start_line = start[1]
   --          local start_col = start[2] + 1
   --          local _end = vim.api.nvim_buf_get_mark(0, ">")
   --          local end_line = _end[1]
   --          local end_l = vim.fn.getline(end_line)
   --          local end_col = vim.str_byteindex(
   --             end_l,
   --             -- Use `math.min()` because it might lead to 'index out of range' error
   --             -- when mark is positioned at the end of line (that extra space which is
   --             -- selected when selecting with `v$`)
   --             vim.str_utfindex(end_l, math.min(#end_l, _end[2] + 1))
   --          )
   --          print(start_line, start_col, end_line, end_col)
   --          print(vim.inspect(vim.api.nvim_call_function("getline", { start_line, end_line })))
   --          -- return start_line, start_col, end_line, end_col
   --          -- ────────────────────────────────────────────────────────────
   --          -- print(vim.inspect(vim.api.nvim_buf_get_mark(0, "<")), vim.inspect(vim.api.nvim_buf_get_mark(0, ">")))
   --          -- starting_point=vim.api.nvim_buf_get_mark(0, "<")
   --          -- ending_point= vim.api.nvim_buf_get_mark(0, ">")
   --          -- print('start : ' .. vim.inspect(starting_point))
   --          -- print('end : '.. vim.inspect(ending_point))
   --       end,
   --       "bold",
   --    },
   -- }, {
   --    mode = "x",
   --    silent = true,
   --    buffer = vim.api.nvim_get_current_buf(),
   -- })
   -- vim.api.nvim_set_keymap('x', ',w', '<cmd>lua print(vim.inspect(vim.api.nvim_buf_get_mark(0, "<")), vim.inspect(vim.api.nvim_buf_get_mark(0, ">")))<cr>', {})
   -- vim.api.nvim_set_keymap('v', ',w', '<cmd>lua print(vim.inspect(vim.api.nvim_buf_get_mark(0, "<")), vim.inspect(vim.api.nvim_buf_get_mark(0, ">")))<cr>', {})
end
