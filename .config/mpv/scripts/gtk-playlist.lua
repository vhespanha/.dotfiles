-- ==UserScript==
-- @name         mpv-playlist-kdialog
-- @version      0.1
-- @description  Display mpv playlist and select playlist entry in KDE's kdialog or Gnome's zenity.
-- @author       ftk
-- @license      0BSD
-- @downloadURL  https://gist.githubusercontent.com/ftk/5e26656a2ec9a6cb0fef46918f741d0a/raw/mpv-playlist-kdialog.lua
-- ==/UserScript==
local options = {
  -- window dimensions
  width = 750,
  heigth = 600,
  reopen_on_select = false,
  reopen_on_track_change = false,
}

require("mp.options").read_options(options)

local utils = require("mp.utils")

local function playlist_kdialog()
  local arr = mp.get_property_native("playlist")
  local args = {
    "kdialog",
    "--title=mpv playlist",
    "--icon=mpv",
    "--geometry=" .. utils.to_string(options.width) .. "x" .. utils.to_string(options.heigth),
    "--radiolist",
    "Select playlist entry",
    "--",
  }
  for i, v in ipairs(arr) do
    -- kdialog
    table.insert(args, utils.to_string(i))
    table.insert(args, v.title or v.filename or utils.to_string(i))
    table.insert(args, v.playing and "on" or "off")
  end

  local res = mp.command_native({
    name = "subprocess",
    args = args,
    capture_stdout = true,
    playback_only = options.reopen_on_track_change,
    capture_size = 32,
  })
  local success = false
  if res.status == 0 and tonumber(res.stdout) and tonumber(res.stdout) > 0 then
    mp.set_property_native("playlist-pos-1", tonumber(res.stdout))
    success = true
  end
  if (success and options.reopen_on_select) or (options.reopen_on_track_change and res.killed_by_us) then
    mp.add_timeout(0.1, playlist_kdialog)
  end
end

local function playlist_zenity()
  local arr = mp.get_property_native("playlist")
  local args = {
    "zenity",
    "--modal",
    "--width=" .. utils.to_string(options.width),
    "--height=" .. utils.to_string(options.heigth),
    "--title=mpv playlist",
    "--list",
    "--text=Select playlist entry",
    "--column=N",
    "--column=ID",
    "--column=Name",
    "--column=Path",
    "--radiolist",
    "--print-column=2",
    "--hide-column=2",
    "--mid-search",
    "--",
  }
  for i, v in ipairs(arr) do
    -- zenity
    table.insert(args, v.playing and "true" or "false")
    table.insert(args, utils.to_string(i))
    table.insert(args, v.title or utils.to_string(i))
    table.insert(args, v.filename or "?")
  end
  local res = mp.command_native({
    name = "subprocess",
    args = args,
    capture_stdout = true,
    playback_only = options.reopen_on_track_change,
    capture_size = 32,
  })
  local success = false
  if res.status == 0 and tonumber(res.stdout) and tonumber(res.stdout) > 0 then
    mp.set_property_native("playlist-pos-1", tonumber(res.stdout))
    success = true
  end
  if (success and options.reopen_on_select) or (options.reopen_on_track_change and res.killed_by_us) then
    mp.add_timeout(0.1, playlist_zenity)
  end
end

mp.add_key_binding("Ctrl+p", "zenity_open_playlist", playlist_zenity)
