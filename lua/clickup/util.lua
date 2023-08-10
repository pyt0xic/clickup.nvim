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

