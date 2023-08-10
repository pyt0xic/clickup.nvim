---@class Config
---@field options Options
local M = {}

---@class Options
---@field api_token string
---@field list_id string
local defaults = {
  api_token = "",
  list_id = "",
}

---@type Options
M.options = {}

--- Set the plugin options
---@param opts Options?
function M.setup(opts)
  M.options = vim.tbl_extend("force", {}, defaults, opts or {})
  vim.notify("M.options " .. vim.inspect(M.options))
end

---Merge opts with the plugin options
---@param opts Options?
---@return Options
function M.merge(opts)
  return vim.tbl_extend("force", M.options, opts)
end

M.setup()

return M
