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
    local previous_day_header = nil
    local unchecked_items = {}
    local collecting_children = false
    local parent_indent_level = nil

    -- Check for today's header and gather unchecked items from the last day
    for i, line in ipairs(lines) do
        if line:match("^# " .. date_today) then
            today_exists = true
            break
        elseif line:match("^# %d%d%d%d%-%d%d%-%d%d") then
            previous_day_header = i
            collecting_children = false  -- Stop collecting when a new header is found
        elseif previous_day_header and line:match("^%- %[ %]") then
            local indent_level = #line:match("^%s*")  -- Determine the indentation level

            -- Start a new unchecked parent task or continue with a sibling task
            if parent_indent_level == nil or indent_level <= parent_indent_level then
                table.insert(unchecked_items, line)
                parent_indent_level = indent_level
                collecting_children = true
            elseif collecting_children and indent_level > parent_indent_level then
                -- Include child task only if collecting and it's indented
                table.insert(unchecked_items, line)
            end
        elseif previous_day_header and not line:match("^%- %[ %]") and not line:match("^# %d%d%d%d%-%d%d%-%d%d") then
            -- If we encounter a non-task line (not a task or a header), stop collecting children
            collecting_children = false
        end
    end

    -- If today’s header doesn’t exist and the previous day is present, add it and transfer unchecked items
    if not today_exists and previous_day_header then
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
