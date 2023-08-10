local config = require("clickup.config")
local tasks = require("clickup.tasks")

local M = {}

M.setup = config.setup
M.display_tasks = tasks.display_tasks

return M
