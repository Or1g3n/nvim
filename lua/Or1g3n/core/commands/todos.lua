local fn = vim.fn
local cmd = vim.cmd

-- Function to handle todos.md automation
local function markdown_update_todos()
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
    local inside_sub_header = false
    local current_sub_header = nil
    local header_added = false
    local final_lines = {}

    -- Loop through file and find max date header. Also remove empty lines (will be added back later)
    for i, line in ipairs(lines) do
        if line:match('^# %d%d%d%d%-%d%d%-%d%d') then
            current_date = line:match('%d%d%d%d%-%d%d%-%d%d')
            if max_date == nil or current_date > max_date then
                max_date = current_date
            end
	elseif line == '' then
	    table.insert(lines_to_remove, i)
        end
    end

    -- Check if today is present in file
    if max_date == date_today then
        today_exists = true
    end

    -- If today is not present find max_date then collect all unchecked tasks and subtasks
    if today_exists == false then
	-- Remove all empty lines
        for i = #lines_to_remove, 1, -1 do  -- Remove from the end to avoid index shifting
            table.remove(lines, lines_to_remove[i])
        end
	-- Reset lines_to_remove
	lines_to_remove = {}

        for i, line in ipairs(lines) do
            if line:match('^# %d%d%d%d%-%d%d%-%d%d') and line:match('%d%d%d%d%-%d%d%-%d%d') == max_date then
                inside_previous_date = true
            end

            if inside_previous_date then
		if line:match('^## *') then
		    if line ~= lines[current_sub_header] then
			inside_sub_header = true
			current_sub_header = i
			header_added = false
		    end
		end
                if line:match('%- %[[ xX]%]') or line:match('%- ') then
                    indent_level = #line:match('^%s*')
                    if indent_level == 0 then
                        if line:match('%- %[ %]') then
                            start_collecting = true
			    if inside_sub_header and header_added == false then
				table.insert(unchecked_items, lines[current_sub_header])
				-- table.insert(lines_to_remove, current_sub_header)
				header_added = true
			    end
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

        table.insert(lines, "# " .. date_today)

        -- Extend lines with unchecked items, preserving their structure
        for _, item in ipairs(unchecked_items) do
            table.insert(lines, item)
        end

	-- Add empty lines back if header
        for i, line in ipairs(lines) do
	    if line:match('^#') and (i + 1 <= #lines and lines[i + 1]:match('^#') and not line:match('^# %d%d%d%d%-%d%d%-%d%d')) then
		-- do nothing
	    elseif line:match('^#') or (i + 1 <= #lines and lines[i + 1]:match('^#')) then
		table.insert(final_lines, line)
		table.insert(final_lines, '')
	    else
		table.insert(final_lines, line)
	    end
	end

        fn.writefile(final_lines, todos_file)
    end

    -- Open the file in Neovim
    cmd("edit " .. todos_file)
end

-- Define a command for easy access
vim.api.nvim_create_user_command("MarkdownUpdateTodos", markdown_update_todos, { desc = "Markdown: Open Todos markdown file and run date entry automation"})
-- Set up keybinding to call :MarkdownUpdateTodos
vim.api.nvim_set_keymap("n", "<leader>t", ":MarkdownUpdateTodos<CR>",
    {
	noremap = true,
	silent = true,
	callback = function()
	    if vim.bo.filetype ~= "NvimTree" then
		vim.cmd("MarkdownUpdateTodos")
	    end
	end
    }
)
