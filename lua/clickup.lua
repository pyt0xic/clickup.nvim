local config = require("clickup.config")
local tasks = require("clickup.tasks")

local M = {}

M.client = require("clickup.client")
M.display_tasks = tasks.display_tasks
M.setup = config.setup

return M
