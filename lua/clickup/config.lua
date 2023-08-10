---@class Options
---@field api_token string
---@field list_id string

---@class Config
---@field options Options
local config = {}

---@type Options
config.options = {
  api_token = "",
  list_id = "",
}

--- Set the plugin options
---@param opts Options
function config.set_options(opts)
  config.options = vim.tbl_extend("force", config.options, opts)
end

return config
