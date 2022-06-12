-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- ────────────────────────────────────────────────────────────
local lsp = require("lib.lsp")
local logger = require("lib.logger")()
local msg = ""
-- ────────────────────────────────────────────────────────────
local lsp_server_name = "dockerls"
local opts = {
   on_attach = function(client, bufnr)
      -- have null-ls control formatting
      client.resolved_capabilities.document_formatting = false
      client.resolved_capabilities.document_range_formatting = false
      msg = string.format("[ %s ] on_attach function called", lsp_server_name)
         -- stylua: ignore start
         if logger then logger:trace(msg) end
      -- stylua: ignore end
      require("lib.lsp-config").lsp_status(client, bufnr)
   end,
   settings = {
      docker = {
         languageserver = {
            diagnostics = {
               -- MAINTAINER has been deprecated
               deprecatedMaintainer = "warning",
               -- Parser directives should be written in lowercase letters
               directiveCasing = "warning",
               -- Empty continuation lines are not allowed
               emptyContinuationLine = "warning",
               -- Instructions should be written in uppercase letters
               instructionCasing = "error",
               -- Dockerfiles can only have one CMD instruction.
               -- If multiple are defined, the last one is the one which will take effect
               instructionCmdMultiple = "error",
               -- Dockerfiles can only have one ENTRYPOINT instruction in them.
               -- If multiple are defined, the last one is the only one that will take effect
               instructionEntrypointMultiple = "error",
               -- Dockerfiles can only have one HEALTHCHECK instruction in them.
               -- If multiple are defined, the last one is the only one that will take effect
               instructionHealthcheckMultiple = "error",
               -- Instruction written as a JSON array but is using single quotes instead of double quotes
               instructionJSONInSingleQuotes = "error",
            },
            formatter = {
               ignoreMultilineInstructions = true,
            },
         },
      },
   },
}
lsp:setup(lsp_server_name, opts)
