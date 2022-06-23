-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
--
return function(register)
   if not register then
      return
   end
   register({
      name = "+LSP",
      i = { ":LspInfo<cr>", "Connected Language Servers" },
      A = { "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", "Add workspace folder" },
      R = { "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", "Remove workspace folder" },
      l = { "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", "List workspace" },
      D = { "<cmd>lua vim.lsp.buf.type_definition()<CR>", "Type definition" },
      r = { "<cmd>lua vim.lsp.buf.rename()<CR>", "Rename" },
      e = { "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", "Show line diagnostic" },
      q = { "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", "Set loclist" },
      -- [ NOTE ] definately look into this
      -- https://github.com/vzytoi/nvim.lua/blob/main/lua/plugins/formatter/formats.lua
      f = { "<cmd>lua vim.lsp.buf.format({async = true})<CR>", "Format" },
   }, {
      mode = "n",
      prefix = "<leader>l",
      buffer = nil,
      silent = true,
      noremap = true,
      nowait = true,
   })
   register({
      ["a"] = {
         "<cmd>lua vim.lsp.buf.code_action()<CR>",
         "+Code action",
      },
   }, {
      mode = "n",
      buffer = nil,
      silent = true,
      noremap = true,
      nowait = true,
   })

   -- map(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>")
   -- map(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
   -- map(bufnr, "n", "<C-w>gd", "<cmd>split | lua vim.lsp.buf.definition()<CR>")
   -- map(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
   -- map(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>")
   -- map(bufnr, "n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<CR>")
   -- map(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
   -- map(bufnr, "n", "<C-w>gi", "<cmd>split | lua vim.lsp.buf.implementation()<CR>")
   -- map(bufnr, "n", "gt", "<cmd>lua vim.lsp.buf.type_definition()<CR>")
   -- map(bufnr, "n", "<space>gw", "<cmd>lua vim.lsp.buf.document_symbol()<CR>")
   -- map(bufnr, "n", "<space>gW", "<cmd>lua vim.lsp.buf.workspace_symbol()<CR>")
   -- map(bufnr, "n", "<space>gh", "<cmd>lua vim.lsp.buf.hover()<CR>")
   -- map(bufnr, "n", "<space>gr", "<cmd>lua require('config.plugins.lspconfig.utils').rename()<CR>")
   -- map(bufnr, "n", "<space>g=", "<cmd>lua vim.lsp.buf.formatting()<CR>")
   -- map(bufnr, "n", "<space>gi", "<cmd>lua vim.lsp.buf.incoming_calls()<CR>")
   -- map(bufnr, "n", "<space>go", "<cmd>lua vim.lsp.buf.outgoing_calls()<CR>")
   -- map(bufnr, "n", "<space>gd", "<cmd>lua vim.diagnostic.open_float({focusable = false, border = 'single' })<CR>")
end
