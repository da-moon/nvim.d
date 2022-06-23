-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- ╭──────────────────────────────────────────────────────────╮
-- │                  remove carriage return                  │
-- ╰──────────────────────────────────────────────────────────╯
-- vim.cmd [[ au BufWritePre * %s/\s\+$//e ]]
vim.cmd([[ au BufWritePre * silent! :%s/\r\n/\r]])
-- ╭──────────────────────────────────────────────────────────╮
-- │       autmatically reload file if changed on disk        │
-- ╰──────────────────────────────────────────────────────────╯
vim.cmd([[ au CursorHold * checktime]])
-- ╭──────────────────────────────────────────────────────────╮
-- │                 open dashboard on start                  │
-- ╰──────────────────────────────────────────────────────────╯
vim.cmd('autocmd FileType dashboard lua require("autocmd.dashboard.on_enter")()')
-- ╭──────────────────────────────────────────────────────────╮
-- │                   terminal keybindings                   │
-- ╰──────────────────────────────────────────────────────────╯
-- Add cursorline and diasable it in terminal
-- vim.cmd 'autocmd WinEnter,BufEnter * if &ft is "toggleterm" | set nocursorline | else | set cursorline | endif'
vim.cmd('autocmd! TermOpen,TermEnter  term://* lua require("autocmd.terminal.on_enter")()')
-- ╭──────────────────────────────────────────────────────────╮
-- │                  nvim-tree keybindings                   │
-- ╰──────────────────────────────────────────────────────────╯
-- disable certain keybindings when cursor is on nvim-tree
vim.cmd('autocmd FileType NvimTree lua require("autocmd.nvim-tree.on_enter")()')
