local curl = require("plenary.curl")
local url_encode = require("clickup.util").urlencode

--- @class ClickUpClient
local M = {}

--- Get tasks from a list.
--- @param api_token string: ClickUp API token.
--- @param params table: Request parameters including pathParams and queryParams.
--- @return table|nil, string: Decoded API response or error message.
function M.get_tasks(api_token, params)
  local base_url = "https://api.clickup.com/api/v2/list/"
  local list_id = params.pathParams.list_id
  local url = base_url .. list_id .. "/task"
  local query_params = params.queryParams
  if query_params then
    local query_parts = {}
    for key, value in pairs(query_params) do
      table.insert(query_parts, key .. "=" .. url_encode(value))
    end
    local query_string = table.concat(query_parts, "&")
    if query_string ~= "" then
      url = url .. "?" .. query_string
    end
  end
  vim.notify(url)
  -- make request
  local response, err = curl.get(url, {
    accept = "application/json",
    raw = { "-H", "Authorization: " .. api_token },
    timeout = 30000,
  })
  -- return response
  if response and response.body then
    local decoded_response = vim.fn.json_decode(response.body)
    return decoded_response, ""
  else
    return nil, err or "API request failed"
  end
end

--- Start a new time entry.
--- @param api_token string: ClickUp API token.
--- @param params table: Request parameters including pathParams and queryParams.
--- @return table|nil, string: Decoded API response or error message.
function M.start_time_entry(api_token, params)
  local base_url = "https://api.clickup.com/api/v2/team/"
  local team_id = params.pathParams.team_id
  local url = base_url .. team_id .. "/time_entries/start"
  local query_params = params.queryParams
  if query_params and query_params.custom_task_ids and query_params.team_id then
    local custom_task_ids = query_params.custom_task_ids
    local team_id_query = query_params.team_id
    url = url .. "?custom_task_ids=" .. url_encode(custom_task_ids) .. "&team_id=" .. url_encode(team_id_query)
  end
  local request_body = vim.fn.json_encode(params.body)
  -- make request
  local response, err = curl.post(url, {
    accept = "application/json",
    data = request_body,
    raw = { "-H", "Authorization: " .. api_token },
    timeout = 30000,
  })
  -- return response
  if response and response.body then
    local decoded_response = vim.fn.json_decode(response.body)
    return decoded_response, ""
  else
    return nil, err or "API request failed"
  end
end

--- Stop a running time entry.
--- @param api_token string: ClickUp API token.
--- @param team_id number: Team ID.
--- @return table|nil, string: Decoded API response or error message.
function M.stop_time_entry(api_token, team_id)
  local base_url = "https://api.clickup.com/api/v2/team/"
  local url = base_url .. team_id .. "/time_entries/stop"
  -- make request
  local response, err = curl.post(url, {
    accept = "application/json",
    raw = { "-H", "Authorization: " .. api_token },
    timeout = 30000,
  })
  -- return response
  if response and response.body then
    local decoded_response = vim.fn.json_decode(response.body)
    return decoded_response, ""
  else
    return nil, err or "API request failed"
  end
end

--- Create a new time entry.
--- @param api_token string: ClickUp API token.
--- @param params table: Request parameters including pathParams and queryParams.
--- @return table|nil, string: Decoded API response or error message.
function M.create_time_entry(api_token, params)
  local base_url = "https://api.clickup.com/api/v2/team/"
  local team_id = params.pathParams.team_id
  local url = base_url .. team_id .. "/time_entries"
  local query_params = params.queryParams
  if query_params and query_params.custom_task_ids and query_params.team_id then
    local custom_task_ids = query_params.custom_task_ids
    local team_id_query = query_params.team_id
    url = url .. "?custom_task_ids=" .. url_encode(custom_task_ids) .. "&team_id=" .. url_encode(team_id_query)
  end
  local request_body = vim.fn.json_encode(params.body)
  -- make request
  local response, err = curl.post(url, {
    accept = "application/json",
    data = request_body,
    raw = { "-H", "Authorization: " .. api_token },
    timeout = 30000,
  })
  -- return response
  if response and response.body then
    local decoded_response = vim.fn.json_decode(response.body)
    return decoded_response, ""
  else
    return nil, err or "API request failed"
  end
end

--- Delete time entries.
--- @param api_token string: ClickUp API token.
--- @param team_id number: Team ID.
--- @param timer_ids table: Array of timer IDs to delete.
--- @return table|nil, string: Decoded API response or error message.
function M.delete_time_entry(api_token, team_id, timer_ids)
  local base_url = "https://api.clickup.com/api/v2/team/"
  local url = base_url .. team_id .. "/time_entries"
  local timer_ids_string = table.concat(timer_ids, ",")
  -- make request
  local response, err = curl.delete(url, {
    accept = "application/json",
    raw = { "-H", "Authorization: " .. api_token },
    data = { timer_ids = timer_ids_string },
    timeout = 30000,
  })
  -- return response
  if response and response.body then
    local decoded_response = vim.fn.json_decode(response.body)
    return decoded_response, ""
  else
    return nil, err or "API request failed"
  end
end

--- Update a time entry.
--- @param api_token string: ClickUp API token.
--- @param params table: Request parameters including pathParams and queryParams.
--- @return table|nil, string: Decoded API response or error message.
function M.update_time_entry(api_token, params)
  local base_url = "https://api.clickup.com/api/v2/team/"
  local team_id = params.pathParams.team_id
  local timer_id = params.pathParams.timer_id
  local url = base_url .. team_id .. "/time_entries/" .. timer_id
  local query_params = params.queryParams
  if query_params and query_params.custom_task_ids and query_params.team_id then
    local custom_task_ids = query_params.custom_task_ids
    local team_id_query = query_params.team_id
    url = url .. "?custom_task_ids=" .. url_encode(custom_task_ids) .. "&team_id=" .. url_encode(team_id_query)
  end
  local request_body = params.body
  -- make request
  local response, err = curl.put(url, {
    accept = "application/json",
    data = vim.fn.json_encode(request_body),
    raw = { "-H", "Authorization: " .. api_token },
    timeout = 30000,
  })
  -- return response
  if response and response.body then
    local decoded_response = vim.fn.json_decode(response.body)
    return decoded_response, ""
  else
    return nil, err or "API request failed"
  end
end

--- Get time entries.
--- @param api_token string: ClickUp API token.
--- @param params table: Request parameters including pathParams and queryParams.
--- @return table|nil, string: Decoded API response or error message.
function M.get_time_entries(api_token, params)
  local base_url = "https://api.clickup.com/api/v2/team/"
  local team_id = params.pathParams.team_id
  local url = base_url .. team_id .. "/time_entries"
  local query_params = params.queryParams
  if query_params then
    local query_parts = {}
    for key, value in pairs(query_params) do
      if value ~= nil then
        table.insert(query_parts, key .. "=" .. url_encode(value))
      end
    end
    local query_string = table.concat(query_parts, "&")
    if query_string ~= "" then
      url = url .. "?" .. query_string
    end
  end
  -- make request
  local response, err = curl.get(url, {
    accept = "application/json",
    raw = { "-H", "Authorization: " .. api_token },
    timeout = 30000,
  })
  -- return response
  if response and response.body then
    local decoded_response = vim.fn.json_decode(response.body)
    return decoded_response, ""
  else
    return nil, err or "API request failed"
  end
end

--- Get running time entry for an assignee.
--- @param api_token string: ClickUp API token.
--- @param team_id number: Team ID.
--- @param assignee number: Assignee ID.
--- @return table|nil, string: Decoded API response or error message.
function M.get_running_time_entry(api_token, team_id, assignee)
  local base_url = "https://api.clickup.com/api/v2/team/"
  if not assignee then
    return nil, "Assignee is required"
  end
  local url = base_url .. team_id .. "/time_entries/current"
  url = url .. "?assignee=" .. url_encode(assignee)
  -- make request
  local response, err = curl.get(url, {
    accept = "application/json",
    raw = { "-H", "Authorization: " .. api_token },
    timeout = 30000,
  })
  -- return response
  if response and response.body then
    local decoded_response = vim.fn.json_decode(response.body)
    return decoded_response, ""
  else
    return nil, err or "API request failed"
  end
end

--- Create a new task.
--- @param api_token string: ClickUp API token.
--- @param list_id number: List ID.
--- @param params table: Request parameters including queryParams.
--- @return table|nil, string: Decoded API response or error message.
function M.create_task(api_token, list_id, params)
  local base_url = "https://api.clickup.com/api/v2/list/"
  local url = base_url .. list_id .. "/task"
  local query_params = params.queryParams
  if query_params then
    local query_parts = {}
    for key, value in pairs(query_params) do
      table.insert(query_parts, key .. "=" .. url_encode(value))
    end
    local query_string = table.concat(query_parts, "&")
    if query_string ~= "" then
      url = url .. "?" .. query_string
    end
  end
  local request_body = vim.fn.json_encode(params.body)
  -- make request
  local response, err = curl.post(url, {
    accept = "application/json",
    data = request_body,
    raw = { "-H", "Authorization: " .. api_token },
    timeout = 30000,
  })
  -- return response
  if response and response.body then
    local decoded_response = vim.fn.json_decode(response.body)
    return decoded_response, ""
  else
    return nil, err or "API request failed"
  end
end

--- Update an existing task.
--- @param api_token string: ClickUp API token.
--- @param task_id number: Task ID.
--- @param params table: Request parameters including queryParams.
--- @return table|nil, string: Decoded API response or error message.
function M.update_task(api_token, task_id, params)
  local base_url = "https://api.clickup.com/api/v2/task/"
  local url = base_url .. task_id
  local query_params = params.queryParams
  if query_params then
    local query_parts = {}
    for key, value in pairs(query_params) do
      table.insert(query_parts, key .. "=" .. url_encode(value))
    end
    local query_string = table.concat(query_parts, "&")
    if query_string ~= "" then
      url = url .. "?" .. query_string
    end
  end
  local request_body = vim.fn.json_encode(params.body)
  -- make request
  local response, err = curl.put(url, {
    accept = "application/json",
    data = request_body,
    raw = { "-H", "Authorization: " .. api_token },
    timeout = 30000,
  })
  -- return response
  if response and response.body then
    local decoded_response = vim.fn.json_decode(response.body)
    return decoded_response, ""
  else
    return nil, err or "API request failed"
  end
end

-- Delete a task.
--- @param api_token string: ClickUp API token.
--- @param task_id number: Task ID.
--- @param params table: Request parameters including queryParams.
--- @return table|nil, string: Decoded API response or error message.
function M.delete_task(api_token, task_id, params)
  local base_url = "https://api.clickup.com/api/v2/task/"
  local url = base_url .. task_id
  local query_params = params.queryParams
  if query_params then
    local query_parts = {}
    for key, value in pairs(query_params) do
      table.insert(query_parts, key .. "=" .. url_encode(value))
    end
    local query_string = table.concat(query_parts, "&")
    if query_string ~= "" then
      url = url .. "?" .. query_string
    end
  end
  -- make request
  local response, err = curl.delete(url, {
    accept = "application/json",
    raw = { "-H", "Authorization: " .. api_token },
    timeout = 30000,
  })
  -- return response
  if response and response.body then
    local decoded_response = vim.fn.json_decode(response.body)
    return decoded_response, ""
  else
    return nil, err or "API request failed"
  end
end

--- Get comments for a task.
--- @param api_token string: ClickUp API token.
--- @param task_id number: Task ID.
--- @param params table: Request parameters including queryParams.
--- @return table|nil, string: Decoded API response or error message.
function M.get_task_comments(api_token, task_id, params)
  local base_url = "https://api.clickup.com/api/v2/task/"
  local url = base_url .. task_id .. "/comment"
  local query_params = params.queryParams
  if query_params then
    local query_parts = {}
    for key, value in pairs(query_params) do
      table.insert(query_parts, key .. "=" .. url_encode(value))
    end
    local query_string = table.concat(query_parts, "&")
    if query_string ~= "" then
      url = url .. "?" .. query_string
    end
  end
  -- make request
  local response, err = curl.get(url, {
    accept = "application/json",
    raw = { "-H", "Authorization: " .. api_token },
    timeout = 30000,
  })
  -- return response
  if response and response.body then
    local decoded_response = vim.fn.json_decode(response.body)
    return decoded_response, ""
  else
    return nil, err or "API request failed"
  end
end

--- Create a new comment for a task.
--- @param api_token string: ClickUp API token.
--- @param task_id number: Task ID.
--- @param params table: Request parameters including queryParams.
--- @return table|nil, string: Decoded API response or error message.
function M.create_task_comment(api_token, task_id, params)
  local base_url = "https://api.clickup.com/api/v2/task/"
  local url = base_url .. task_id .. "/comment"
  local query_params = params.queryParams
  if query_params then
    local query_parts = {}
    for key, value in pairs(query_params) do
      table.insert(query_parts, key .. "=" .. url_encode(value))
    end
    local query_string = table.concat(query_parts, "&")
    if query_string ~= "" then
      url = url .. "?" .. query_string
    end
  end
  local request_body = vim.fn.json_encode(params.body)
  -- make request
  local response, err = curl.post(url, {
    accept = "application/json",
    data = request_body,
    raw = { "-H", "Authorization: " .. api_token },
    timeout = 30000,
  })
  -- return response
  if response and response.body then
    local decoded_response = vim.fn.json_decode(response.body)
    return decoded_response, ""
  else
    return nil, err or "API request failed"
  end
end

--- Update an existing comment.
--- @param api_token string: ClickUp API token.
--- @param comment_id number: Comment ID.
--- @param params table: Request parameters including queryParams.
--- @return table|nil, string: Decoded API response or error message.
function M.update_comment(api_token, comment_id, params)
  local base_url = "https://api.clickup.com/api/v2/comment/"
  local url = base_url .. comment_id
  local request_body = vim.fn.json_encode(params.body)
  -- make request
  local response, err = curl.put(url, {
    accept = "application/json",
    data = request_body,
    raw = { "-H", "Authorization: " .. api_token },
    timeout = 30000,
  })
  -- return response
  if response and response.body then
    local decoded_response = vim.fn.json_decode(response.body)
    return decoded_response, ""
  else
    return nil, err or "API request failed"
  end
end

--- Delete a comment.
--- @param api_token string: ClickUp API token.
--- @param comment_id number: Comment ID.
--- @return boolean, string: True if successful, false if not or error message.
function M.delete_comment(api_token, comment_id)
  local base_url = "https://api.clickup.com/api/v2/comment/"
  local url = base_url .. comment_id
  -- make request
  local response, err = curl.delete(url, {
    accept = "application/json",
    raw = { "-H", "Authorization: " .. api_token },
    timeout = 30000,
  })
  -- return response
  if response and response.status == 204 then
    return true, ""
  else
    return false, err or "API request failed"
  end
end

return M
