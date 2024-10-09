local M = {}

-- Get the currently playing song
M.get_now_playing = function()
  local handle = io.popen("playerctl metadata --format '  {{ title }}' 2>&1")
  if handle then
    local result = handle:read("*a")
    handle:close()
    if result:find("No player could handle this command") then
      return "󰝛"
    elseif result ~= "" then
      return result:gsub("\n", "")
    else
      return "󰝛"
    end
  end
  return ""
end

-- Toggle play/pause for the current player
M.toggle_play_pause = function()
  os.execute("playerctl play-pause")
end

return M
