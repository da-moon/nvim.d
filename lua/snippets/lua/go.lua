-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab
-- code: language=lua insertSpaces=true tabSize=3
-- local events = require "luasnip.util.events"

local ls = require("luasnip")
-- local sn = ls.snippet_node
-- local isn = ls.indent_snippet_node
-- local f = ls.function_node
-- local c = ls.choice_node
-- local d = ls.dynamic_node
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

local apm_span = s({ trig = "apm:span", name = "apm span", dscr = "creates apm span from context" }, {
   t({ [[span, ctx := apm.StartSpan(ctx, "]] }),
   i(1, "function_name"),
   t({ [[", "]] }),
   i(2, "type_name"),
   t({ '")', "defer span.End()" }),
   i(0),
})

local map_string_interface = s(
   { trig = "msi", name = "map[string]interface{}", dscr = "map string interface definition shorthand" },
   {
      t({ "map[string]interface{}" }),
      i(0),
   }
)

local map_string_interface_insert = s(
   { trig = "msi", name = "map[string]interface{}{}", dscr = "map string interface with insert" },
   {
      t({ "map[string]interface{}{", '"' }),
      i(1, "key"),
      t({ '":' }),
      i(2, "value"),
      t({ ",", "}" }),
      i(0),
   }
)

local map_key_value = s({ trig = "map", name = "map[<key>]<value>", dscr = "map short hand" }, {
   t({ "map[" }),
   i(1, "key"),
   t({ "]" }),
   i(2, "value"),
   i(0),
})

return {
   apm_span,
   map_string_interface,
   map_string_interface_insert,
   map_key_value,
}
