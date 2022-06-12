-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- ────────────────────────────────────────────────────────────
-- https://github.com/xeluxee/competitest.nvim/blob/master/lua/competitest/utils.lua
-- ────────────────────────────────────────────────────────────
local M = {}

---Return true if the given file exists, otherwise false
---@param filepath string
---@return boolean
function M.does_file_exists(filepath)
   local fd = vim.loop.fs_open(filepath, "r", 438)
   if fd == nil then
      return false
   else
      assert(vim.loop.fs_close(fd), [[[ lib/file ] does_file_exists: unable to
		close ']] .. filepath .. "'")
      return true
   end
end

---This function returns the content of the specified file as a string, or nil
--if the given path is invalid
---@param filepath string
---@return string | nil
function M.load_file_as_string(filepath)
   local fd = vim.loop.fs_open(filepath, "r", 438)
   if fd == nil then
      return nil
   end
   local stat = assert(vim.loop.fs_fstat(fd), [[[ lib/file ]
	load_file_as_string: cannot stat file ']] .. filepath .. "'")
   local content = assert(vim.loop.fs_read(fd, stat.size, 0), [[[ lib/file ]
	load_file_as_string: cannot read file ']] .. filepath .. "'")
   assert(vim.loop.fs_close(fd), [[[ lib/file ] load_file_as_string: unable to
	close ']] .. filepath .. "'")
   return string.gsub(content, "\r\n", "\n") -- convert CRLF to LF
end

---Create the specified directory if it doesn't exist
---@param dirpath string: directory absolute path
function M.mkdir(dirpath)
   if not vim.loop.fs_opendir(dirpath) then
      dirpath = string.gsub(dirpath, "[/\\]+$", "") -- trim trailing slashes
      local upper_dir = vim.fn.fnamemodify(dirpath, ":h")
      if upper_dir ~= dirpath then
         M.create_directory(upper_dir)
      end
      assert(vim.loop.fs_mkdir(dirpath, 493), [[[ lib/file ] create_directory:
		cannot create directory ']] .. dirpath .. "'")
   end
end

---Write the content of the given string on a file
---@param filepath string
---@param content string
function M.write_string_on_file(filepath, content)
   M.create_directory(vim.fn.fnamemodify(filepath, ":h"))
   local fd = assert(vim.loop.fs_open(filepath, "w", 420), [[[ lib/file ]
	write_string_on_file: cannot open file ']] .. filepath .. "'")
   assert(vim.loop.fs_write(fd, content, 0), [[[ lib/file ]
	write_string_on_file: cannot write on file ']] .. filepath .. "'")
   assert(vim.loop.fs_close(fd), [[[ lib/file ] write_string_on_file: unable to
	close ']] .. filepath .. "'")
end

---Delete the given file
---@param filepath string
function M.delete_file(filepath)
   assert(vim.loop.fs_unlink(filepath), [[[ lib/file ] delete_file: cannot
	delete file ']] .. filepath .. "'")
end
return M
