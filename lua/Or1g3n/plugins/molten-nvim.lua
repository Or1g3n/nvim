return {
    "benlubas/molten-nvim",
    version = "^1.0.0", -- Use version <2.0.0 to avoid breaking changes
    build = ":UpdateRemotePlugins",
    init = function()
	-- Output settings
	vim.g.molten_output_win_max_height = 12
	vim.g.molten_auto_open_output = false
	vim.g.molten_wrap_output = true
	-- Virtual text settings
	vim.g.molten_virt_text_output = true
	vim.g.molten_virt_lines_off_by_1 = true
	vim.g.molten_virt_text_max_lines = 25

	-- Keymaps
	vim.keymap.set("n", "<A-r><A-i>", ":MoltenInit<CR>", { silent = true, desc = "Molten: Initialize plugin" })
	vim.keymap.set("n", "<A-r><A-t>", ":MoltenDeinit<CR>", { silent = true, desc = "Molten: De-initialize plugin" })
	vim.keymap.set("n", "<A-r><A-d>", ":MoltenDelete<CR>", { silent = true, desc = "Molten: Delete cell" })

	vim.keymap.set("n", "<A-r><A-e>", ":MoltenEvaluateOperator<CR>", { silent = true, desc = "Molten: Run operator selection" })
	vim.keymap.set("n", "<A-r><A-r>", ":MoltenEvaluateLine<CR>", { silent = true, desc = "Molten: Evaluate line" })
	vim.keymap.set("n", "<A-r><A-c>", ":MoltenReevaluateCell<CR>", { silent = true, desc = "Molten: Re-evaluate cell" })
	vim.keymap.set("n", "<A-r><A-a>", ":MoltenReevaluateAll<CR>", { silent = true, desc = "Molten: Re-evaluate all cells" })
	vim.keymap.set("v", "<A-r>", ":<C-u>MoltenEvaluateVisual<CR>gv<Esc>", { silent = true, desc = "Molten: Evaluate visual selection" })
	vim.keymap.set("v", "<C-CR>", ":<C-u>MoltenEvaluateVisual<CR>gv<Esc>", { silent = true, desc = "Molten: Evaluate visual selection" })

	vim.keymap.set("n", "<A-r><A-h>", ":MoltenHideOutput<CR>", { silent = true, desc = "Molten: Hide output" })
	vim.keymap.set("n", "<A-r><A-o>",
	    function()
		local file_extension = vim.fn.bufname():match('^.+%.([^.]+)')
		if file_extension == 'ipynb' then
		    vim.cmd("noautocmd MoltenEnterOutput")
		    vim.cmd("noautocmd MoltenEnterOutput")
		else
		    vim.cmd("noautocmd MoltenEnterOutput")
		end
	    end,
	    { silent = true, desc = "Molten: Show/enter output" }
	)

	vim.keymap.set("n", "<A-r><A-n>", ":MoltenNext<CR>", { silent = true, desc = "Molten: Goto next cell" })
	vim.keymap.set("n", "<A-r><A-p>", ":MoltenPrev<CR>", { silent = true, desc = "Molten: Goto previous cell" })

	-- Toggle on/off virtual text
	vim.keymap.set(
	    "n", "<A-r><A-v>",
	    function()
		if require("molten.status").initialized() == "Molten" and vim.g.molten_virt_text_output then
		    vim.fn.MoltenUpdateOption("virt_text_output", false)
		else
		    vim.fn.MoltenUpdateOption("virt_text_output", true)
		end
	    end,
	    { silent = true, desc = "Molten: Toggle virt_text_output" }
	)

	-- Define cell_tags based on format and filetype
	local cell_tags = {
	    markdown = {
		python = {
		    cell_start = '```python',
		    cell_end = '```'
		},
		lua = {
		    cell_start = '```lua',
		    cell_end = '```'
		},
	    },
	    non_markdown = {
		python = {
		    cell_start = '# %%',
		    cell_end = ''
		},
		lua = {
		    cell_start = '-- %%',
		    cell_end = ''
		},
	    }
	}

	-- Define function to identify start and end positions of non_markdown cell blocks
	local function define_cell_block()
	    -- Determine cell tag
	    local filetype = vim.bo.filetype
	    local cell_tag = cell_tags.non_markdown[filetype].cell_start or 'No match'
	    -- Set search term to markdown header to easily navigate cells with n, N
	    vim.cmd(":let @/ = '" .. cell_tag .. "'")
	    -- Get current line text
	    local cur_line = vim.api.nvim_get_current_line()
	    -- Initialize cell block
	    local cell_block = {
		start_pos = nil,
		end_pos = nil
	    }
	    -- Get start position for cell block
	    if cur_line:match("^" .. cell_tag) then
		cell_block.start_pos = vim.fn.line(".")
	    else
		cell_block.start_pos = vim.fn.search("^" .. cell_tag, "b") -- Search backward for # %%
	    end
	    if cell_block.start_pos == 0 then
		print("No cell marker found above")
		return
	    end
	    -- Get end position for cell block
	    cell_block.end_pos = vim.fn.search("^" .. cell_tag, "W") -- Search forward for # %%
	    if cell_block.end_pos == 0 then
		cell_block.end_pos = vim.fn.line("$")             -- Select till end of file if no marker below
	    else
		cell_block.end_pos = cell_block.end_pos - 2
	    end
	    -- Return cell_block
	    if cell_block.start_pos and cell_block.end_pos then
		return cell_block
	    end
	end

	-- Define function to auto-find and run cells
	local function run_cell(next_cell)
	    next_cell = next_cell or false -- Determines whether to move to next cell after running. default to false
	    -- Get cell_block start and end positions
	    local cell_block = define_cell_block()
	    -- If visual_only then select cell range else auto-run cell
	    if next_cell then
		vim.fn.MoltenEvaluateRange(cell_block.start_pos, cell_block.end_pos)
	    else
		vim.fn.MoltenEvaluateRange(cell_block.start_pos, cell_block.end_pos)
		vim.api.nvim_win_set_cursor(0, { cell_block.start_pos, 0 })
	    end
	end

	vim.keymap.set("n", "<S-CR>", function() run_cell(true) end, { silent = true, desc = "Molten: run cell and move to next" })
	vim.keymap.set("n", "<A-r><A-b>", function() run_cell(true) end, { silent = true, desc = "Molten: run cell and move to next" })
	vim.keymap.set("n", "<A-r><A-g>", function() run_cell(false) end, { silent = true, desc = "Molten: run cell" })
	vim.keymap.set("n", "<C-CR>", function() run_cell(false) end, { silent = true, desc = "Molten: run cell" })

	-- Function to check if Otter LSP is active for a buffer
	local function is_otter_active(bufnr)
	    local clients = vim.lsp.get_clients({
		bufnr = bufnr,
		name = 'otter-ls[' .. bufnr .. ']'
	    })
	    return #clients > 0  -- Returns true if the Otter LSP client is attached
	end

	-- Autcommands
	-- Change the configuration when editing a python file
	vim.api.nvim_create_autocmd("BufEnter", {
	    pattern = "*.py",
	    callback = function(e)
		if string.match(e.file, ".otter.") then
		    return
		end
		if require("molten.status").initialized() == "Molten" then -- This is kinda a hack...
		    vim.fn.MoltenUpdateOption("virt_lines_off_by_1", false)
		    vim.fn.MoltenUpdateOption("virt_text_output", false)
		    vim.fn.MoltenUpdateOption("molten_auto_open_output", true)
		else
		    vim.g.molten_virt_lines_off_by_1 = false
		    vim.g.molten_virt_text_output = false
		    vim.g.molten_auto_open_output = false
		end
	    end,
	})

	-- Undo those config changes when we go back to a markdown or quarto file
	vim.api.nvim_create_autocmd("BufEnter", {
	    pattern = { "*.qmd", "*.md", "*.ipynb" },
	    callback = function(e)
		-- Determine cell_tags depending on how .ipynb was formatted
		local is_markdown = vim.bo.filetype == 'markdown'
		local tags = nil
		if is_markdown then
		    tags = cell_tags.markdown.python
		else
		    tags = cell_tags.non_markdown.python
		end

		if string.match(e.file, ".otter.") then
		    return
		end
		if require("molten.status").initialized() == "Molten" then
		    if is_markdown then
			vim.fn.MoltenUpdateOption("virt_lines_off_by_1", true)
		    else
			vim.fn.MoltenUpdateOption("virt_lines_off_by_1", false)
		    end
		    vim.fn.MoltenUpdateOption("virt_text_output", true)
		    vim.fn.MoltenUpdateOption("molten_auto_open_output", false)
		else
		    vim.g.molten_virt_lines_off_by_1 = false
		    vim.g.molten_virt_text_output = true
		    vim.g.molten_auto_open_output = false
		end

		-- Add keymaps for smart up / down motions
		-- TODOS:
		-- if on top most or bottom most cell, it will still move to cell tag rather than non move at all -- COMPLETE
		-- non_markdown end tags need to be handled better as empty lines within a code block cause problems

		-- Cache last start and end positions of code block
		local code_block_boundaries = {
		    start_pos = vim.fn.search("^" .. tags.cell_start .. '$', "ncb"),
		    end_pos = vim.fn.search("^" .. tags.cell_end .. '$', "ncW")
		}

		local function is_skip_line(line_num)
		    local line_text = vim.fn.getline(line_num)
		    local prev_line_text = vim.fn.getline(line_num - 1)
		    local next_line_text = vim.fn.getline(line_num + 1)
		    return
			(
			    line_text == ''
			    and prev_line_text:match('^' .. tags.cell_end .. '$') ~= nil
			    and next_line_text:match('^' .. tags.cell_start .. '$') ~= nil
			)
			or line_text == tags.cell_start
			or (tags.cell_end ~= '' and line_text == tags.cell_end)
		end

		local function get_code_block_boundaries()
		    code_block_boundaries.start_pos = vim.fn.search("^" .. tags.cell_start .. '$', "ncb")
		    code_block_boundaries.end_pos = vim.fn.search("^" .. tags.cell_end .. '$', "ncW")
		end

		local function in_code_block(line_num)
		    if code_block_boundaries.start_pos == 0 and code_block_boundaries.end_pos == 0 then
			vim.notify('current pos: ' .. line_num .. ', ' .. 'start pos: ' .. code_block_boundaries.start_pos .. ', end pos: ' .. code_block_boundaries.end_pos)
			get_code_block_boundaries()
		    end

		    if line_num > code_block_boundaries.start_pos and line_num < code_block_boundaries.end_pos then
			return true
		    else
			get_code_block_boundaries()
			vim.notify('current pos: ' .. line_num .. ', ' .. 'start pos: ' .. code_block_boundaries.start_pos .. ', end pos: ' .. code_block_boundaries.end_pos)
			return false
		    end
		end

		local function smart_down()
		    local count = vim.v.count
		    if count > 0 then
			return vim.cmd("normal! " .. count .. "j")
		    end

		    local cur_num = vim.fn.line(".")
		    local next_num = cur_num + 1
		    local next_text = vim.fn.getline(next_num)
		    local max_num = vim.fn.line("$")

		    if (next_num == max_num) and (next_text == tags.cell_start or next_text == tags.cell_end) then
			return
		    end

		    if in_code_block(next_num) then
			return vim.cmd("normal! " .. "j")
		    end

		    while cur_num < max_num do
			cur_num = cur_num + 1
			if not is_skip_line(cur_num) then
			    break
			end
		    end

		    vim.api.nvim_win_set_cursor(0, { cur_num, 0 })
		    get_code_block_boundaries()
		end

		local function smart_up()
		    local count = vim.v.count
		    if count > 0 then
			return vim.cmd("normal! " .. count .. "k")
		    end

		    local cur_num = vim.fn.line(".")
		    local prev_num = cur_num - 1
		    local prev_text = vim.fn.getline(cur_num - 1)

		    if (prev_num == 1) and (prev_text == tags.cell_start or prev_text == tags.cell_end) then
			return
		    end

		    if in_code_block(prev_num) then
			return vim.cmd("normal! " .. "k")
		    end

		    while cur_num > 1 do
			cur_num = cur_num - 1
			if not is_skip_line(cur_num) then
			    break
			end
		    end
		    vim.api.nvim_win_set_cursor(0, { cur_num, 0 })
		    get_code_block_boundaries()
		end

		vim.keymap.set('n', 'j', smart_down, { buffer = true, desc = "Smart down (skip cell tags)" })
		vim.keymap.set('n', 'k', smart_up,   { buffer = true, desc = "Smart up (skip cell tags)" })

		-- Add keymap for adding/removing new code blocks
		-- Add new block after current
		vim.keymap.set('n', '<A-n>',
		    function()
			local lines = {}
			local next_block_end = 0
			local is_empty = vim.fn.line('$') == 1 and vim.fn.getline(1) == ''
			if not is_empty then
			    if is_markdown then
				-- Markdown blocks have a real end tag
				next_block_end = vim.fn.search("^" .. tags.cell_end .. '$', "cW")
				if next_block_end == 0 then
				    next_block_end = vim.fn.line("$")
				end
			    else
				-- Non-markdown: look for next cell_start instead
				local next_start = vim.fn.search("^" .. tags.cell_start, "W")
				if next_start == 0 then
				    next_block_end = vim.fn.line("$") -- No more cells, append to EOF
				else
				    next_block_end = next_start - 1 -- Insert before next cell
				end
			    end
			end
			-- Add extra empty line if markdown format or end of file
			if is_empty == false and (is_markdown or (next_block_end == vim.fn.line("$") and vim.fn.getline("$") ~= '')) then
			    table.insert(lines, "")
			end
			vim.list_extend(lines, {
			    tags.cell_start,
			    "",
			    tags.cell_end,
			})
			if is_empty then
			    vim.api.nvim_buf_set_lines(0, 0, 1, true, lines)
			else
			    vim.fn.append(next_block_end, lines)
			end
			-- Move cursor inside the new block
			vim.api.nvim_win_set_cursor(0, { next_block_end + #lines - 1, 0 })
		    end,
		    { buffer = true, desc = "Insert new Python code block after current", }
		)

		-- Add new block before current
		vim.keymap.set('n', '<A-b>',
		    function()
			local cur_line = vim.api.nvim_get_current_line()
			local prev_block_start = nil
			-- Save the cursor position
			if cur_line:match("^" .. tags.cell_start) then
			    prev_block_start = vim.fn.line(".")
			else
			    prev_block_start = vim.fn.search("^" .. tags.cell_start, "b")
			end
			-- Insert new code block
			local lines = {}
			vim.list_extend(lines, {
			    tags.cell_start,
			    "",
			    tags.cell_end,
			})
			if is_markdown then
			    table.insert(lines, "")
			end
			vim.fn.append(prev_block_start - 1, lines)
			-- Move cursor to inside the new code block
			vim.api.nvim_win_set_cursor(0, { prev_block_start + 1, 0 })
		    end,
		    { buffer = true, desc = "Insert new Python code block before current" }
		)

		-- Delete block and move to prior
		vim.keymap.set('n', '<A-d><A-d>',
		    function()
			local multiplier = vim.v.count1  -- Get the multiplier (defaults to 1 if no multiplier)
			for i = 1, multiplier do
			    local last_line_num = vim.fn.line('$')
			    if is_markdown then
				local block_start_num = vim.fn.search('^' .. tags.cell_start .. '$', 'cb')
				local next_block_end_num = vim.fn.search('^' .. tags.cell_end .. '$', 'cW')
				if next_block_end_num == 0 and block_start_num == 0 then
				    return
				elseif block_start_num == 1 and next_block_end_num == last_line_num then
				    vim.cmd.normal("dab")
				elseif next_block_end_num < last_line_num then
				    vim.cmd.normal("vabjd[b") -- Remove code block and below line
				else
				    vim.cmd.normal("vabokddd[b") -- Remove code block and above line
				end
			    else
				local cell_block = define_cell_block()
				if cell_block == nil then return end -- Exit if no blocks found
				if cell_block.end_pos == last_line_num then
				    vim.cmd(cell_block.start_pos .. ',' .. cell_block.end_pos .. ' delete')
				else
				    vim.cmd(cell_block.start_pos .. ',' .. cell_block.end_pos + 1 .. ' delete')
				end
			    end
			end
		    end,
		    { buffer = true, desc = "Delete code block and jump to previous" }
		)

	    end,
	})
    end,
}
