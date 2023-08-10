vim.api.nvim_create_user_command("ClickUpTasks", require("clickup").display_tasks(), {})
