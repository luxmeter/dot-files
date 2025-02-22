-- my own plugins
return {
	{
		name = "callhierarchy",
		enabled = true,
		dir = "~/Projects/neovim/callhierarchy",
		opt = {},
	},
	{
		name = "mongojuuid",
		enabled = true,
		dir = "~/Projects/neovim/mongojuuid",
		cmd = { "MapToBinData", "MapToJUUID" },
	},
	{
		name = "goToImplementation",
		enabled = false,
		dir = "~/Projects/neovim/gotoimpl",
		cmd = { "GoToImplementation" },
	},
	{
		name = "virtualtext",
		enabled = true,
		dir = "~/Projects/neovim/virtualtext",
		cmd = { "ToggleVirtualText" },
	},
}
