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
	    end,
	})
    end,
}
