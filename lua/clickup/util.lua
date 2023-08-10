---@class ClickupUtil
local M = {}

--- Convert milliseconds to hours and minutes string
---@param ms number
---@return string
function M.milliseconds_to_hours_minutes(ms)
  if ms == nil or "" then
    return "0h00m"
  end
  local seconds = math.floor(ms / 1000)
  local minutes = math.floor(seconds / 60)
  local hours = math.floor(minutes / 60)
  local remaining_minutes = minutes % 60

  return string.format("%dh%02dm", hours, remaining_minutes)
end

local char_to_hex = function(c)
  return string.format("%%%02X", string.byte(c))
end

---Encode a URL
---@param url string
function M.urlencode(url)
  if url == nil then
    return
  end
  url = url:gsub("\n", "\r\n")
  url = string.gsub(url, "([^%w _%%%-%.~])", char_to_hex)
  url = url:gsub(" ", "+")
  return url
end

return M
