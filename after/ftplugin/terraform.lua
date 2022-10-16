-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- ────────────────────────────────────────────────────────────
-- https://github.com/SurrealTiggi/dotfiles/blob/master/nvim/.config/nvim/lua/lsp/handlers.lua
-- ────────────────────────────────────────────────────────────
local lsp = require("lib.lsp")
local logger = require("lib.logger")()
local msg = ""
-- ────────────────────────────────────────────────────────────
local lsp_servers = {
   "terraformls",
   -- "tflint",
}
for _, lsp_server_name in ipairs(lsp_servers) do
   local opts = {
      on_attach = function(client, bufnr)
         -- have null-ls control formatting
         client.server_capabilities.document_formatting = false
         msg = string.format("[ %s ] on_attach function called", lsp_server_name)
         -- stylua: ignore start
         if logger then logger:trace(msg) end
         -- stylua: ignore end
         require("lib.lsp-config").lsp_status(client, bufnr)
      end,
   }
   if lsp_server_name == "terraformls" then
      msg = string.format("[ %s ] specific opts", lsp_server_name)
      -- stylua: ignore start
      if logger then logger:trace(msg) end
      -- stylua: ignore end
      opts = vim.tbl_deep_extend("force", opts, {
         -- cmd = { vim.fn.stdpath("data") .. "/lsp_servers/terraform/terraform-ls", "serve" },
         cmd = { "terraform-ls", "serve" },
         filetypes = { "terraform", "tf" },
         root_dir = require("lspconfig/util").root_pattern(".terraform", ".git", "*.tf"),
         -- root_dir = vim.fn.getcwd(),
      })
   end
   lsp:setup(lsp_server_name, opts)
end
