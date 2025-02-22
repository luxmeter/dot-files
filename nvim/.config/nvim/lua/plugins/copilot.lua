return {
	"zbirenbaum/copilot.lua",
	enabled = true,
	cmd = "Copilot",
	build = ":Copilot auth",
	event = "InsertEnter",
	opts = {
		suggestion = { enabled = true, auto_trigger = true, keymap = {
			accept = "<m-l>",
		} },
		panel = { enabled = true },
	},
}
