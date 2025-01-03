return {
    "benlubas/molten-nvim",
    version = "^1.0.0", -- use version <2.0.0 to avoid breaking changes
    build = ":UpdateRemotePlugins",
    init = function()
	local map = vim.keymap

	-- Output settings
	vim.g.molten_output_win_max_height = 12
	vim.g.molten_auto_open_output = false
	vim.g.molten_wrap_output = true
	-- Virtual text settings
	vim.g.molten_virt_text_output = true
	vim.g.molten_virt_lines_off_by_1 = true

	-- Keymaps
	map.set("n", "<A-r><A-i>", ":MoltenInit<CR>", { silent = true, desc = "Molten: Initialize plugin" })
	map.set("n", "<A-r><A-t>", ":MoltenDeinit<CR>", { silent = true, desc = "Molten: De-initialize plugin" })
	map.set("n", "<A-r><A-d>", ":MoltenDelete<CR>", { silent = true, desc = "Molten: Delete cell" })

	map.set("n", "<A-r><A-e>", ":MoltenEvaluateOperator<CR>", { silent = true, desc = "Molten: Run operator selection" })
	map.set("n", "<A-r><A-r>", ":MoltenEvaluateLine<CR>", { silent = true, desc = "Molten: Evaluate line" })
	map.set("n", "<A-r><A-c>", ":MoltenReevaluateCell<CR>", { silent = true, desc = "Molten: Re-evaluate cell" })
	map.set("n", "<A-r><A-a>", ":MoltenReevaluateAll<CR>", { silent = true, desc = "Molten: Re-evaluate all cells" })
	map.set("v", "<A-r>", 	   ":<C-u>MoltenEvaluateVisual<CR>gv<Esc>", { silent = true, desc = "Molten: Evaluate visual selection" })

	map.set("n", "<A-r><A-h>", ":MoltenHideOutput<CR>", { silent = true, desc = "Molten: Hide output" })
	map.set("n", "<A-r><A-o>", ":noautocmd MoltenEnterOutput<CR>", { silent = true, desc = "Molten: Show/enter output" })

	map.set("n", "<A-r><A-n>", ":MoltenNext<CR>", { silent = true, desc = "Molten: Goto next cell" })
	map.set("n", "<A-r><A-p>", ":MoltenPrev<CR>", { silent = true, desc = "Molten: Goto previous cell" })

	-- Define function to auto-find cells
	local function run_cell(auto_run)
	    auto_run = auto_run or false -- default to false

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
	    if auto_run then
		vim.fn.MoltenEvaluateRange(start_pos,end_pos)
	    else
		vim.api.nvim_feedkeys(start_pos .. "G V " .. end_pos .. "G", 'n' , false)
	    end
	end

	map.set( "n", "<A-r><A-b>", function() run_cell(true) end, { silent = true, desc = "Molten: Auto-identify and run cell" })
	map.set( "n", "<A-r><A-g>", function() run_cell(false) end, { silent = true, desc = "Molten: Auto-identify and select cell" })

    end,
}
