local fn = vim.fn
local cmd = vim.cmd

local map = vim.keymap
local command = vim.api.nvim_create_user_command

-- Function to toggle the checkbox
local function md_toggle_checkboxes(start_line, end_line)
    -- Get current mode
    local mode = vim.fn.mode()

    -- If no lines are provided, get the current line
    if start_line == nil or end_line == nil then
        if mode == 'v' or mode == 'V' or mode == '<C-v>' then
            start_line, end_line = fn.getpos("'<")[2], fn.getpos("'>")[2]
        else
            start_line, end_line = fn.line('.'), fn.line('.')
        end
    end

    for line_num = start_line, end_line do
        local line = fn.getline(line_num)

	-- Toggle logic
        if line:find('%[x%]') then
            line = line:gsub('%[x%]', '[ ]')  -- Change checked to unchecked
        elseif line:find('%[ %]') then
            line = line:gsub('%[ %]', '[x]')  -- Change unchecked to checked
        end

        fn.setline(line_num, line)
    end
end

-- Define a command for easy access
command("MarkdownToggleCheckBox", function(opts) md_toggle_checkboxes(opts.line1, opts.line2) end, { desc = "Markdown: Toggle checkboxes", range = true })  -- enable range support

-- Set up keybinding to call :MarkdownToggleCheckBox
map.set({'n', 'v'}, '<A-m><A-c>', ':MarkdownToggleCheckBox<CR>', { noremap = true, silent = true, desc = 'Markdown: Toggle checkboxes' })
