-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- ────────────────────────────────────────────────────────────
local lsp = require("lib.lsp")
local logger = require("lib.logger")()
local msg = ""
-- ────────────────────────────────────────────────────────────
local lsp_servers = {
   "ansiblels",
   "yamlls",
}
for _, lsp_server_name in ipairs(lsp_servers) do
   local opts = {}
   if lsp_server_name == "ansiblels" then
      opts = vim.tbl_deep_extend("force", opts, {
         filetypes = { "yaml.ansible", "ansible" },
         settings = {
            ansible = {
               ansible = {
                  path = "ansible",
               },
               ansibleLint = {
                  enabled = true,
                  path = "ansible-lint",
               },
               executionEnvironment = {
                  enabled = false,
               },
               python = {
                  interpreterPath = "python3",
               },
            },
         },
      })
   end
   if lsp_server_name == "yamlls" then
      opts = vim.tbl_deep_extend("force", opts, {
         filetypes = {
            "yaml",
            "yml",
            "gitlab-ci",
            "yaml.ansible",
            "ansible",
            "yaml.docker-compose",
            "docker-compose",
         },
         settings = {
            yaml = {
               trace = {
                  server = "verbose",
               },
               validate = false,
               schemaDownload = { enable = true },
               schemas = {
                  kubernetes = { "/*.yaml", "/*.yml" },
                  ["https://github.com/docker/compose/raw/master/compose/config/compose_spec.json"] = {
                     "/docker-compose.yaml",
                     "/*docker-compose.yaml",
                     "/docker-compose.yml",
                     "/*docker-compose.yml",
                  },
                  ["https://json.schemastore.org/github-workflow.json"] = { "/.github/workflows/*.yml" },
                  ["https://gitlab.com/gitlab-org/gitlab/-/raw/master/app/assets/javascripts/editor/schema/ci.json"] = {
                     "/*gitlab-ci.yml",
                     "/*gitlab-ci.yaml",
                  },
               },
            },
         },
      })
   end
   lsp:setup(lsp_server_name, opts)
end
