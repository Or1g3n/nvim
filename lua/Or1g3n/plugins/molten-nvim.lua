return {
    "benlubas/molten-nvim",
    version = "^1.0.0", -- use version <2.0.0 to avoid breaking changes
    build = ":UpdateRemotePlugins",
    init = function()

	-- Output settings
	vim.g.molten_output_win_max_height = 12
	vim.g.molten_auto_open_output = false
	vim.g.molten_wrap_output = true
	-- Virtual text settings
	vim.g.molten_virt_text_output = true
	vim.g.molten_virt_lines_off_by_1 = true

	-- Keymaps
	vim.keymap.set("n", "<A-r><A-i>", ":MoltenInit<CR>", { silent = true, desc = "Molten: Initialize plugin" })
	vim.keymap.set("n", "<A-r><A-t>", ":MoltenDeinit<CR>", { silent = true, desc = "Molten: De-initialize plugin" })
	vim.keymap.set("n", "<A-r><A-d>", ":MoltenDelete<CR>", { silent = true, desc = "Molten: Delete cell" })

	vim.keymap.set("n", "<A-r><A-e>", ":MoltenEvaluateOperator<CR>", { silent = true, desc = "Molten: Run operator selection" })
	vim.keymap.set("n", "<A-r><A-r>", ":MoltenEvaluateLine<CR>", { silent = true, desc = "Molten: Evaluate line" })
	vim.keymap.set("n", "<A-r><A-c>", ":MoltenReevaluateCell<CR>", { silent = true, desc = "Molten: Re-evaluate cell" })
	vim.keymap.set("n", "<A-r><A-a>", ":MoltenReevaluateAll<CR>", { silent = true, desc = "Molten: Re-evaluate all cells" })
	vim.keymap.set("v", "<A-r>", 	  ":<C-u>MoltenEvaluateVisual<CR>gv<Esc>", { silent = true, desc = "Molten: Evaluate visual selection" })
	vim.keymap.set("v", "<C-CR>", 	  ":<C-u>MoltenEvaluateVisual<CR>gv<Esc>", { silent = true, desc = "Molten: Evaluate visual selection" })

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

	-- Define function to auto-find and run cells
	local function run_cell(next_cell)
	    next_cell = next_cell or false -- determines whether to move to next cell after running. default to false

	    -- define cell tags based on filetype
	    local ft_cell_tags = {
		python = '# %%',
		lua = '-- %%'
	    }
	    local filetype = vim.bo.filetype
	    local cell_tag = ft_cell_tags[filetype] or 'No match'

	    -- Set search term to markdown header to easily navigate cells with n, N
	    vim.cmd(":let @/ = '" .. cell_tag .. "'")

	    local cur_line = vim.api.nvim_get_current_line()
	    local start_pos = nil

	    -- Save the cursor position
	    if cur_line:match("^" .. cell_tag) then
		start_pos = vim.fn.line(".")
	    else
		start_pos = vim.fn.search("^" .. cell_tag, "b") -- Search backward for # %%
	    end

	    local end_pos = vim.fn.search("^" .. cell_tag, "W") -- Search forward for # %%
	    if end_pos == 0 then
		end_pos = vim.fn.line("$") -- Select till end of file if no marker below
	    else
		end_pos = end_pos - 2
	    end

	    if start_pos == 0 then
		print("No cell marker found above")
		return
	    end

	    -- If visual_only then select cell range else auto-run cell
	    if next_cell then
		vim.fn.MoltenEvaluateRange(start_pos,end_pos)
	    else
		vim.fn.MoltenEvaluateRange(start_pos,end_pos)
		vim.api.nvim_win_set_cursor(0, {start_pos, 0})
	    end
	end

	vim.keymap.set( "n", "<S-CR>", function() run_cell(true) end, { silent = true, desc = "Molten: run cell and move to next" })
	vim.keymap.set( "n", "<A-r><A-b>", function() run_cell(true) end, { silent = true, desc = "Molten: run cell and move to next" })
	vim.keymap.set( "n", "<A-r><A-g>", function() run_cell(false) end, { silent = true, desc = "Molten: run cell" })
	vim.keymap.set( "n", "<C-CR>", function() run_cell(false) end, { silent = true, desc = "Molten: run cell" })

	-- Autcommands
	-- change the configuration when editing a python file
	vim.api.nvim_create_autocmd("BufEnter", {
	    pattern = "*.py",
	    callback = function(e)
		if string.match(e.file, ".otter.") then
		    return
		end
		if require("molten.status").initialized() == "Molten" then -- this is kinda a hack...
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
		if string.match(e.file, ".otter.") then
		    return
		end
		if require("molten.status").initialized() == "Molten" then
		    vim.fn.MoltenUpdateOption("virt_lines_off_by_1", false)
		    vim.fn.MoltenUpdateOption("virt_text_output", true)
		    vim.fn.MoltenUpdateOption("molten_auto_open_output", false)
		else
		    vim.g.molten_virt_lines_off_by_1 = true
		    vim.g.molten_virt_text_output = true
		    vim.g.molten_auto_open_output = false
		end

		-- add keymap for adding/removing new code blocks
		vim.keymap.set('n', '<A-n>',
		    function()
			local next_block_end = vim.fn.search("^```", "W")
			-- insert new code block
			vim.fn.append(next_block_end, {
			    "",
			    "```python",
			    "",
			    "```"
			})
			-- move cursor to inside the new code block
			vim.api.nvim_win_set_cursor(0, {next_block_end + 3, 0})
		    end,
		    { buffer = true, desc = "Insert new Python code block after current" }
		)
		vim.keymap.set('n', '<A-b>',
		    function()
			local cur_line = vim.api.nvim_get_current_line()
			local prev_block_start = nil
			-- Save the cursor position
			if cur_line:match("^```python") then
			    prev_block_start = vim.fn.line(".")
			else
			    prev_block_start = vim.fn.search("^```python", "b")
			end
			-- insert new code block
			vim.fn.append(prev_block_start -1, {
			    "```python",
			    "",
			    "```",
			    ""
			})
			-- move cursor to inside the new code block
			vim.api.nvim_win_set_cursor(0, {prev_block_start + 1, 0})
		    end,
		    { buffer = true, desc = "Insert new Python code block before current" }
		)
		vim.keymap.set('n', '<A-d>',
		    function()
			-- Delete around block (assumes you've defined `dab` as a code block text object)
			vim.cmd.normal("dab")
			-- Remove trailing blank line if present
			local cur_line = vim.fn.line(".")
			local next_line = vim.fn.getline(cur_line)
			if next_line:match("^%s*$") then
			    vim.api.nvim_buf_set_lines(0, cur_line, cur_line + 1, false, {})
			end
			-- Remove preceding blank line if present
			local prev_line_num = cur_line - 1
			if prev_line_num > 0 then
			    local prev_line = vim.fn.getline(prev_line_num)
			    if prev_line:match("^%s*$") then
				vim.api.nvim_buf_set_lines(0, prev_line_num - 1, prev_line_num, false, {})
				cur_line = cur_line - 1
			    end
			end
			-- Jump to previous block (if defined, e.g. [b with vim-markdown)
			vim.cmd.normal("[b")
		    end,
		    { buffer = true, desc = "Delete code block and jump to previous" }
		)
	    end,
	})
    end,
}
