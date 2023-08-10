-- client module
local clickup = require("clickup.main")

---@type Config
local config = {
  api_token = "",
  list_id = 0,
}

clickup.config = config
clickup.client = require("clickup.client")

---Setup the plugin
---@param args Config?
clickup.setup = function(args)
  clickup.config = vim.tbl_deep_extend("force", clickup.config, args or {})
  clickup.client = require("clickup.client")
end

return clickup
