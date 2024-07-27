local utils = require("mp.utils")
local options = require("mp.options")

local opts = {
  save_file = "~/.config/mpv/playlist_position.txt",
}

options.read_options(opts)

function save_position()
  local pos = mp.get_property_number("playlist-pos", 0)
  local file = io.open(opts.save_file, "w")
  if file then
    file:write(pos)
    file:close()
  end
end

function load_position()
  local file = io.open(opts.save_file, "r")
  if file then
    local pos = tonumber(file:read("*all"))
    file:close()
    if pos then
      mp.set_property_number("playlist-pos", pos)
    end
  end
end

mp.register_event("shutdown", save_position)
mp.register_event("file-loaded", load_position)
