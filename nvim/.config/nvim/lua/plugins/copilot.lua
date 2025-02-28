return {
	"zbirenbaum/copilot.lua",
	enabled = true,
	cmd = "Copilot",
	build = ":Copilot auth",
	event = "InsertEnter",
	opts = {
		suggestion = {
			enabled = true,
			auto_trigger = false,
			keymap = {
				-- next <m-]> previous <m-[>
				accept = "<m-l>",
			},
		},
		panel = { enabled = true },
	},
}
