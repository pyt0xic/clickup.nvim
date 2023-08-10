local config = require("clickup.config")
local client = require("clickup.client")
---@class ClickUp
---@field config Config
---@field client ClickUpClient
local M = {
  client = client,
}

local opts = {}

--- Display the tasks in a buffer
M.display_tasks = function()
  vim.notify(vim.inspect(opts))
  local GetTasksRequest = {
    pathParams = {
      list_id = opts.list_id,
    },
    queryParams = {
      subtasks = "true",
      include_closed = "false",
    },
  }

  local tickets = M.client.get_tasks(opts.api_token, GetTasksRequest).tasks
  local tasks_display = ""

  for _, ticket in ipairs(tickets) do
    tasks_display = tasks_display .. "ID: " .. ticket.id .. "\n"
    tasks_display = tasks_display .. "Name: " .. ticket.name .. "\n"
    tasks_display = tasks_display .. "Status: " .. ticket.status.status .. "\n\n"
  end

  local win_width = 60
  local win_height = math.min(#tickets + 6, 15)

  local win_opts = {
    relative = "editor",
    width = win_width,
    height = win_height,
    row = vim.fn.winheight(0) / 2 - win_height / 2,
    col = vim.fn.winwidth(0) / 2 - win_width / 2,
    border = "single",
    style = "minimal",
  }

  local bufnr = vim.api.nvim_create_buf(false, true)
  local win_id = vim.api.nvim_open_win(bufnr, true, win_opts)

  vim.api.nvim_buf_set_option(bufnr, "bufhidden", "wipe")
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, vim.split(tasks_display, "\n"))

  vim.api.nvim_buf_set_keymap(bufnr, "n", "q", ":q<CR>", { noremap = true, silent = true })
end

---Setup the plugin
---@param args Options?
M.setup = function(args)
  config.set_options(args or {})
end

return M
