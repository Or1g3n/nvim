local fn = vim.fn

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


-- Keymaps for Markdown editing
-- Only active in Markdown files
vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = function()
	local opts = { buffer = true, noremap = true, silent = true }

	-- Text formatting
	map.set("v", "<M-m><M-b>", 'c**<C-r>"**<Esc>', vim.tbl_extend("force", opts, { desc = "Markdown: Bold" }))
	map.set("v", "<M-m><M-i>", 'c*<C-r>"*<Esc>',   vim.tbl_extend("force", opts, { desc = "Markdown: Italic" }))
	map.set("v", "<M-m><M-s>", 'c~~<C-r>"~~<Esc>', vim.tbl_extend("force", opts, { desc = "Markdown: Strikethrough" }))
	-- map.set("v", "<M-m><M-c>", 'c`<C-r>"`<Esc>',   vim.tbl_extend("force", opts, { desc = "Markdown: Inline code" }))
	-- map.set("v", "<M-m><M-C>", 'c```<CR><C-r>"<CR>```<Esc>', vim.tbl_extend("force", opts, { desc = "Markdown: Code block" }))

	-- Links & media
	map.set("v", "<M-m><M-l>", 'c[<C-r>"]()<Esc>F)i', vim.tbl_extend("force", opts, { desc = "Markdown: Link" }))
	-- map.set("v", "<M-m><M-p>", 'c![<C-r>"]()<Esc>F)i', vim.tbl_extend("force", opts, { desc = "Markdown: Image" }))

	-- Structure
	map.set({'n', 'v'}, '<A-m><A-c>', ':MarkdownToggleCheckBox<CR>', vim.tbl_extend("force", opts, { desc = 'Markdown: Toggle checkboxes' }))

	map.set("n", "<M-m><M-q>", "I> <Esc>",  vim.tbl_extend("force", opts, { desc = "Markdown: Quote (normal)" }))
	map.set("v", "<M-m><M-q>", ":s/^/> /<CR>", vim.tbl_extend("force", opts, { desc = "Markdown: Quote (visual)" }))

	map.set("n", "<M-m><M-o>", "I1. <Esc>", vim.tbl_extend("force", opts, { desc = "Markdown: Ordered list (normal)" }))
	map.set("v", "<M-m><M-o>", ":s/^/1. /<CR>", vim.tbl_extend("force", opts, { desc = "Markdown: Ordered list (visual)" }))

	map.set("n", "<M-m><M-u>", "I- <Esc>",  vim.tbl_extend("force", opts, { desc = "Markdown: Unordered list (normal)" }))
	map.set("v", "<M-m><M-u>", ":s/^/- /<CR>", vim.tbl_extend("force", opts, { desc = "Markdown: Unordered list (visual)" }))

	map.set("n", "<M-m><M-1>", "I# <Esc>",   vim.tbl_extend("force", opts, { desc = "Markdown: Heading 1" }))
	map.set("n", "<M-m><M-2>", "I## <Esc>",  vim.tbl_extend("force", opts, { desc = "Markdown: Heading 2" }))
	map.set("n", "<M-m><M-3>", "I### <Esc>", vim.tbl_extend("force", opts, { desc = "Markdown: Heading 3" }))

	map.set("n", "<M-m><M-h>", "o---<Esc>", vim.tbl_extend("force", opts, { desc = "Markdown: Horizontal rule" }))
    end,
})
