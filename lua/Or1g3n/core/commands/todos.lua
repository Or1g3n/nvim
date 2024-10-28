local fn = vim.fn
local cmd = vim.cmd

-- Function to handle todos.md automation
local function update_todos()
    -- Get current date and home directory path
    local date_today = os.date("%Y-%m-%d")
    local home_dir = os.getenv("HOME") or os.getenv("USERPROFILE")  -- Cross-platform home directory
    local todos_file = home_dir .. "/todos.md"  -- Path to todos.md in home directory

    -- Create the file if it doesn't exist
    if fn.filereadable(todos_file) == 0 then
        fn.writefile({}, todos_file)
    end

    -- Open the file and read lines
    local lines = fn.readfile(todos_file)
    local today_exists = false
    local unchecked_items = {}
    local indent_level = nil
    local start_collecting = nil
    local max_date = nil
    local current_date = nil
    local inside_previous_date = false
    local lines_to_remove = {}  -- To store indices of lines to remove
    
    -- Loop through file and find max date header
    for i, line in ipairs(lines) do 
        if line:match('^# %d%d%d%d%-%d%d%-%d%d') then
            current_date = line:match('%d%d%d%d%-%d%d%-%d%d')
            if max_date == nil or current_date > max_date then
                max_date = current_date
            end
        end
    end

    -- Check if today is present in file
    if max_date == date_today then
        today_exists = true
    end
    
    -- If today is not present find max_date then collect all unchecked tasks and subtasks
    if today_exists == false then 
        for i, line in ipairs(lines) do
            if line:match('^# %d%d%d%d%-%d%d%-%d%d') and line:match('%d%d%d%d%-%d%d%-%d%d') == max_date then
                inside_previous_date = true
            end

            if inside_previous_date then
                if line:match('%- %[[ xX]%]') or line:match('%- ') then
                    indent_level = #line:match('^%s*')
                    if indent_level == 0 then
                        if line:match('%- %[ %]') then
                            start_collecting = true
                            table.insert(unchecked_items, line)
			    table.insert(lines_to_remove, i)
                        else
                            start_collecting = false
                        end
                    else
                        if start_collecting then
                            table.insert(unchecked_items, line)
			    table.insert(lines_to_remove, i)
                        end
                    end
                end
            end
        end

	-- Remove lines after collecting unchecked items
        for i = #lines_to_remove, 1, -1 do  -- Remove from the end to avoid index shifting
            table.remove(lines, lines_to_remove[i])
        end
        
        table.insert(lines, "")  -- Ensure a blank line before new header
        table.insert(lines, "# " .. date_today)
        table.insert(lines, "")  -- Ensure a blank line after the header

        -- Extend lines with unchecked items, preserving their structure
        for _, item in ipairs(unchecked_items) do
            table.insert(lines, item)
        end
        
        fn.writefile(lines, todos_file)
    end

    -- Open the file in Neovim
    cmd("edit " .. todos_file)
end

-- Define a command for easy access
vim.api.nvim_create_user_command("UpdateTodos", update_todos, {})
-- Set up keybinding to call :UpdateTodos
vim.api.nvim_set_keymap("n", "<leader>t", ":UpdateTodos<CR>", { noremap = true, silent = true })
