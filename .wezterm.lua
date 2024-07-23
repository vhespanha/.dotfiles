local wezterm = require("wezterm")
local config = {}

config.font = wezterm.font("JetBrains Mono")
config.font_size = 12.0
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}
config.color_scheme = "Batman"
config.enable_wayland = true
config.front_end = "WebGpu"

return config
