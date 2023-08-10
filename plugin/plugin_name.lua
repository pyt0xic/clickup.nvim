vim.api.nvim_create_user_command("ClickUpTasks", require("clickup.main").display_tasks(), {})
