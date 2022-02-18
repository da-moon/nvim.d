-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- stylua: ignore start
vim.o.shell = "/bin/bash"               --- set shell
vim.o.mouse = "a"                       --- Enable mouse
vim.o.modelines = 5                     --- Search the top and bottom 5 lines for modelines

vim.o.encoding = "utf-8"                --- The encoding displayed
vim.o.fileencoding = "utf-8"            --- The encoding written to file
vim.o.fileencodings = "utf-8"
vim.o.fileformat = "unix"

vim.o.showcmd = true
vim.o.cmdheight = 2                     --- Give more space for displaying messages

vim.o.splitright = true                 --- Vertical splits will automatically be to the right

vim.o.updatetime = 100                  --- Faster completion
vim.o.timeoutlen = 300                  --- Faster completion

vim.o.smartcase = true                  --- Uses case in search
vim.o.smarttab = true                   --- Makes tabbing smarter will realize you have 2 vs 4
vim.o.autoindent = true                 --- Good auto indent
vim.o.expandtab = true
vim.o.showtabline = 2                   --- Always show tabs
vim.o.tabstop = 2                       --- Insert 2 spaces for a tab
vim.o.softtabstop = 2                   --- Insert 2 spaces for a tab
vim.o.shiftwidth = 2                    --- Change a number of space characeters inserted for indentation
-- vim.o.textwidth = 79                    --- default number of columns in a line before moving to next line

vim.o.showmode = false                  --- Don't show things like -- INSERT -- anymore
vim.o.errorbells = false                --- Disables sound effect for errors

vim.o.backup = false                    --- Recommended by coc
vim.o.writebackup = false               --- Recommended by coc

vim.o.swapfile = false                  --- Recommended by coc
vim.o.emoji = false                     --- Fix emoji display
vim.o.undofile = true                   --- Sets undo to file
vim.o.undodir = vim.fn.stdpath "cache" .. "/undo"
vim.o.undolevels = 1000
vim.o.undoreload = 10000

vim.o.viminfo = vim.o.viminfo .. ",n" .. vim.fn.stdpath "cache" .. "/viminfo"

vim.o.incsearch = true                  --- Start searching before pressing enter
vim.o.conceallevel = 0                  --- Show `` in markdown files

vim.o.virtualedit = "block"             --- Block movement can go beyond end-of-line

vim.o.backspace = "indent,eol,start"    --- Making sure backspace works

vim.o.autoread = true                   --- Automatically read a file that has changed on disk

vim.o.lazyredraw = true                 --- Makes macros faster & prevent errors in complicated mappings
-- https://github.com/gchiam/dotfiles/blob/main/.config/nvim/lua/options/general.lua
-- vim.o.wildmode = "list:longest"         --- make TAB behave like in a shell
-- ──────────────────────────────────────────────────────────────────────
-- luacheck: max line length 160
-- https://github.com/camspiers/dotfiles/blob/35161834798d3aea6328567caeba2a3a1f102ed3/files/.config/nvim/lua/options.lua
-- luacheck: max line length 120
-- ──────────────────────────────────────────────────────────────────────
vim.o.wildignore = vim.o.wildignore .. ".DS_Store"
vim.o.wildignore = vim.o.wildignore .. ".git"
vim.o.wildignore = vim.o.wildignore .. ".svn"
vim.o.wildignore = vim.o.wildignore .. ".hg"
vim.o.wildignore = vim.o.wildignore .. "*node_modules/**"
vim.o.wildignore = vim.o.wildignore .. "*.a"
vim.o.wildignore = vim.o.wildignore .. "*.o"
vim.o.wildignore = vim.o.wildignore .. "*.obj"
vim.o.wildignore = vim.o.wildignore .. "*.out"
vim.o.wildignore = vim.o.wildignore .. "*.so"
vim.o.wildignore = vim.o.wildignore .. "*.dll"
vim.o.wildignore = vim.o.wildignore .. "*.exe"
vim.o.wildignore = vim.o.wildignore .. "*.bin"
vim.o.wildignore = vim.o.wildignore .. "*~"
vim.o.wildignore = vim.o.wildignore .. "*.swp"
vim.o.wildignore = vim.o.wildignore .. "*.tmp"
vim.o.wildignore = vim.o.wildignore .. "*.bmp"
vim.o.wildignore = vim.o.wildignore .. "*.gif"
vim.o.wildignore = vim.o.wildignore .. "*.ico"
vim.o.wildignore = vim.o.wildignore .. "*.jpg"
vim.o.wildignore = vim.o.wildignore .. "*.jpeg"
vim.o.wildignore = vim.o.wildignore .. "*.png"
vim.o.wildignore = vim.o.wildignore .. "__pycache__"
vim.o.wildignore = vim.o.wildignore .. "*.pyc"
vim.o.wildignore = vim.o.wildignore .. "*pycache*"
vim.o.wildignore = vim.o.wildignore .. "*.tar"
vim.o.wildignore = vim.o.wildignore .. "*.gz"
vim.o.wildignore = vim.o.wildignore .. "*.bz2"
vim.o.wildignore = vim.o.wildignore .. "*.zstd"
vim.o.wildignore = vim.o.wildignore .. "*.xz"
vim.o.wildignore = vim.o.wildignore .. "*.zip"
vim.o.wildignore = vim.o.wildignore .. "*.ttf"
vim.o.wildignore = vim.o.wildignore .. "*.otf"
vim.o.wildignore = vim.o.wildignore .. "*.woff"
vim.o.wildignore = vim.o.wildignore .. "*.woff2"
vim.o.wildignore = vim.o.wildignore .. "*.eot"
-- ────────────────────────────────────────────────────────────────────────────────
vim.o.scrolloff = 8                     --- Always keep space when scrolling to bottom/top edge

-- Don't always show the sign columns, but if there are, make sure there's room
-- for two. This matches the width of the mode indicator in the statusbar
vim.o.signcolumn = "auto:2"

vim.o.completeopt = "menuone,noselect"  --- Better autocompletion

-- Add angle brackets to the list of recognized characters in a pair
vim.o.matchpairs = vim.o.matchpairs .. ",<:>"
vim.o.showmatch = true                  --- Show matching brackets

vim.o.foldlevel = 5                     --- Only fold sections deeper than this level automatically
vim.o.foldlevelstart = 5                --- Only fold sections deeper than this level automatically

-- https://github.com/ress997/dotfiles-neovim/blob/main/lua/option.lua
if vim.fn.executable "rg" == 1 then
   -- Use rg (ripgrep)
   vim.o.grepprg = "rg --no-heading --vimgrep"
   vim.o.grepformat = "%f:%l:%c:%m"
elseif vim.fn.executable "ag" == 1 then
   -- Use ag (The Silver Searcher)
   vim.o.grepprg = "ag --vimgrep"
   vim.o.grepformat = "%f:%l:%c:%m"
end
if vim.fn.exists "+fixeol" == 1 then
   vim.o.fixendofline = false
end
if vim.fn.exists "+termguicolors" == 1 and vim.env.TERM_PROGRAM ~= "Apple_Terminal" then
   vim.o.termguicolors = true           --- Correct terminal colors
end
-- ────────────────────────────────────────────────────────────────────────────────
vim.opt.formatoptions:append "r"
vim.opt.formatoptions:append "o"
-- ────────────────────────────────────────────────────────────────────────────────
vim.opt.sessionoptions:remove "blank"
vim.opt.sessionoptions:remove "buffers"
vim.opt.sessionoptions:remove "help"
vim.opt.sessionoptions:remove "options"
vim.opt.sessionoptions:remove "globals"
vim.opt.sessionoptions:append "localoptions"
vim.opt.sessionoptions:append "tabpages"

-- ────────────────────────────────────────────────────────────────────────────────
vim.opt.shortmess:append "F"
vim.opt.shortmess:append "c"
-- ────────────────────────────────────────────────────────────────────────────────

-- Allow specified keys that move the cursor left/right to move to the
-- previous/next line when the cursor is on the first/last character in
-- the line
-- https://neovim.io/doc/user/options.html#'whichwrap'
-- https://github.com/mariuszandrzejewski/initvim/blob/main/lua/my/options.lua
vim.opt.whichwrap = vim.opt.whichwrap
   + {
      ["h"] = true,
      ["l"] = true,
      ["<"] = true,
      [">"] = true,
      ["["] = true,
      ["]"] = true,
   }
vim.opt.listchars = { tab = "»─", nbsp = "·", eol = "¬", trail = "-", extends = "»", precedes = "«" }
vim.opt.clipboard = ""
-- stylua: ignore end

-- print("options")
-- vim.o.viminfo = "'1000" --- Increase the size of file history
-- vim.o.foldtext = "CustomFold()" --- Emit custom function for foldtext
