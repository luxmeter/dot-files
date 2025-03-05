local wezterm = require("wezterm")

-- This table will hold the configuration.
local config = wezterm.config_builder()

-- config.color_scheme = "Catppuccin Mocha"
config.color_scheme = "Catppuccin Macchiato"

config.font = wezterm.font("JetBrainsMono Nerd Font")
-- config.font = wezterm.font("Hack Nerd Font")
-- config.font = wezterm.font("FiraCode Nerd Font")
-- config.font = wezterm.font("GoMono Nerd Font")
-- config.font = wezterm.font("Monoid Nerd Font Mono")
-- config.font = wezterm.font("SauceCodePro Nerd Font")
-- config.font = wezterm.font("UbuntuMono Nerd Font")
-- config.font = wezterm.font("GeistMono Nerd Font", { weight = "Regular" })
-- config.font = wezterm.font("MonaspiceKr Nerd Font", { weight = "Regular" })
-- config.font = wezterm.font("MonaspiceNe Nerd Font", { weight = "Regular" })
-- config.font = wezterm.font("MonaspiceAr Nerd Font", { weight = "Regular" })
config.font_size = 13
config.line_height = 1.2
-- config.font_antialias = "Subpixel" -- None, Greyscale, Subpixel
config.window_background_opacity = 1
config.macos_window_background_blur = 25
config.keys = {
	-- Make Option-Left equivalent to Alt-b which many line editors interpret as backward-word
	{ key = "LeftArrow", mods = "OPT", action = wezterm.action({ SendString = "\x1bb" }) },
	-- Make Option-Right equivalent to Alt-f; forward-word
	{ key = "RightArrow", mods = "OPT", action = wezterm.action({ SendString = "\x1bf" }) },
	{
		key = "Enter",
		mods = "OPT",
		action = wezterm.action.DisableDefaultAssignment,
	},
	{ key = "L", mods = "CTRL", action = wezterm.action.DisableDefaultAssignment },
	{ key = "H", mods = "CTRL", action = wezterm.action.DisableDefaultAssignment },
}
return config
