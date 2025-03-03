local ls = require("luasnip")

local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep

local s = ls.snippet
local i = ls.insert_node

ls.add_snippets("gdscript", {
	s(
		"priv",
		fmta(
			[[
print("<name>=%s" % <val>)<finish>
]],
			{
				name = i(1),
				val = rep(1),
				finish = i(0),
			}
		)
	),
})
