-- Function to open kernel variables in floating window
local utils = require('Or1g3n.core.custom.utils')

local state = {
    floating = {
	buf = -1,
	win = -1
    }
}

local show_kernel_vars = function(result)
    local buf = vim.api.nvim_create_buf(false, true)
    local buf_lines = vim.split(result.output, '\n')
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, buf_lines)

    -- If float is open, jump to it
    if vim.api.nvim_win_is_valid(state.floating.win) then
	vim.api.nvim_set_current_win(state.floating.win)
	return
    end

    -- Otherwise, create the float
    local cur_row = vim.fn.winline()
    local cur_height = vim.api.nvim_win_get_height(0)
    local anchor_val = (cur_row < (cur_height / 2)) and 'NW' or 'SW'

    local var_win_config = {
	anchor = anchor_val,
	title = ' Variables ',
	title_pos = 'center',
	relative = 'cursor',
	row = (anchor_val == 'NW') and 1 or 0,
	col = 0,
    }

    state.floating = utils.create_floating_window({
	scaling_factor = .4,
	win_config = var_win_config,
	buf = buf
    })

    -- Set 'q' to close the float
    vim.api.nvim_buf_set_keymap(buf, 'n', 'q', '', {
	nowait = true,
	noremap = true,
	silent = true,
	callback = function()
	    if vim.api.nvim_win_is_valid(state.floating.win) then
		vim.api.nvim_win_close(state.floating.win, true)
	    end
	end,
	desc = "Molten: Close kernel variables float"
    })
end

return {
    "Or1g3n/molten-nvim",
    version = "^1.0.0", -- Use version <2.0.0 to avoid breaking changes
    branch = 'eval-func-with-callback',
    build = ":UpdateRemotePlugins",
    init = function()
	-- Output settings
	vim.g.molten_output_win_max_height = 12
	vim.g.molten_auto_open_output = false
	vim.g.molten_wrap_output = false
	vim.g.molten_cover_empty_lines = true
	-- Virtual text settings
	vim.g.molten_virt_text_output = true
	vim.g.molten_virt_lines_off_by_1 = true
	vim.g.molten_virt_text_max_lines = 25

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
	    local filetype = vim.bo.filetype
	    local cell_tag = cell_tags.non_markdown[filetype] and cell_tags.non_markdown[filetype].cell_start or 'No match'
	    vim.cmd(":let @/ = '" .. cell_tag .. "'")
	    local cur_line = vim.api.nvim_get_current_line()
	    local cell_block = {
		start_pos = 0,
		end_pos = 0
	    }
	    if cur_line:match("^" .. cell_tag) then
		cell_block.start_pos = vim.fn.line(".")
	    else
		cell_block.start_pos = vim.fn.search("^" .. cell_tag, "b")
	    end
	    if cell_block.start_pos == 0 then
		print("No cell marker found above")
		return
	    end
	    cell_block.end_pos = vim.fn.search("^" .. cell_tag, "W")
	    if cell_block.end_pos == 0 then
		cell_block.end_pos = vim.fn.line("$")
	    else
		cell_block.end_pos = cell_block.end_pos - 2
	    end
	    if cell_block.start_pos and cell_block.end_pos then
		return cell_block
	    end
	end

	-- Define function to auto-find and run cells
	local function run_cell(next_cell)
	    next_cell = next_cell or false
	    local cell_block = define_cell_block()
	    if not cell_block then return end
	    if next_cell then
		vim.fn.MoltenEvaluateRange(cell_block.start_pos, cell_block.end_pos)
	    else
		vim.fn.MoltenEvaluateRange(cell_block.start_pos, cell_block.end_pos)
		vim.api.nvim_win_set_cursor(0, { cell_block.start_pos, 0 })
	    end
	end

	-- Set all Molten keymaps buffer-locally via autocommand
	vim.api.nvim_create_autocmd("FileType", {
	    pattern = { "python", "markdown", "quarto", "ipynb" },
	    callback = function()
		vim.keymap.set("n", "<A-r><A-i>", ":MoltenInit<CR>", { silent = true, buffer = true, desc = "Molten: Initialize plugin" })
		vim.keymap.set("n", "<A-r><A-t>", ":MoltenDeinit<CR>", { silent = true, buffer = true, desc = "Molten: De-initialize plugin" })
		vim.keymap.set("n", "<A-r><A-d>", ":MoltenDelete<CR>", { silent = true, buffer = true, desc = "Molten: Delete cell" })
		vim.keymap.set("n", "<A-r><A-e>", ":MoltenEvaluateOperator<CR>", { silent = true, buffer = true, desc = "Molten: Run operator selection" })
		vim.keymap.set("n", "<A-r><A-r>", ":MoltenEvaluateLine<CR>", { silent = true, buffer = true, desc = "Molten: Evaluate line" })
		vim.keymap.set("n", "<A-r><A-c>", ":MoltenReevaluateCell<CR>", { silent = true, buffer = true, desc = "Molten: Re-evaluate cell" })
		vim.keymap.set("n", "<A-r><A-a>", ":MoltenReevaluateAll<CR>", { silent = true, buffer = true, desc = "Molten: Re-evaluate all cells" })
		vim.keymap.set("v", "<A-r>", ":<C-u>MoltenEvaluateVisual<CR>gv<Esc>", { silent = true, buffer = true, desc = "Molten: Evaluate visual selection" })
		vim.keymap.set("v", "<C-CR>", ":<C-u>MoltenEvaluateVisual<CR>gv<Esc>", { silent = true, buffer = true, desc = "Molten: Evaluate visual selection" })
		vim.keymap.set("n", "<A-r><A-y>", ":MoltenYankOutput<CR>", { silent = true, buffer = true, desc = "Molten: Yank output" })
		vim.keymap.set("n", "<Leader><A-r><A-y>", ":MoltenYankOutput!<CR>", { silent = true, buffer = true, desc = "Molten: Yank output (system clipboard)" })
		vim.keymap.set("n", "<A-r><A-h>", ":MoltenHideOutput<CR>", { silent = true, buffer = false, desc = "Molten: Hide output" })
		vim.keymap.set("n", "<A-r><A-o>", function()
		    local file_extension = vim.fn.bufname():match('^.+%.([^.]+)')
		    if file_extension == 'ipynb' then
			vim.cmd("noautocmd MoltenEnterOutput")
			vim.cmd("noautocmd MoltenEnterOutput")
		    else
			vim.cmd("noautocmd MoltenEnterOutput")
		    end
		end, { silent = true, buffer = true, desc = "Molten: Show/enter output" })
		vim.keymap.set("n", "<A-r><A-n>", ":MoltenNext<CR>", { silent = true, buffer = true, desc = "Molten: Goto next cell" })
		vim.keymap.set("n", "<A-r><A-p>", ":MoltenPrev<CR>", { silent = true, buffer = true, desc = "Molten: Goto previous cell" })
		vim.keymap.set("n", "<A-r><A-v>", ":MoltenToggleVirtual<CR>", { silent = true, buffer = true, desc = "Molten: Toggle cell virt_text_output" })
		vim.keymap.set("n", "<Leader><A-r><A-v>", ":MoltenToggleVirtual!<CR>", { silent = true, buffer = true, desc = "Molten: Toggle all cells virt_text_output" })
		vim.keymap.set("n", "<S-CR>", function() run_cell(true) end, { silent = true, buffer = true, desc = "Molten: run cell and move to next" })
		vim.keymap.set("n", "<A-r><A-b>", function() run_cell(true) end, { silent = true, buffer = true, desc = "Molten: run cell and move to next" })
		vim.keymap.set("n", "<A-r><A-g>", function() run_cell(false) end, { silent = true, buffer = true, desc = "Molten: run cell" })
		vim.keymap.set("n", "<C-CR>", function() run_cell(false) end, { silent = true, buffer = true, desc = "Molten: run cell" })
		vim.keymap.set('n', '<A-r><A-k>', function()
		    local code = [[
def _molten_show_vars():
    import pandas as pd
    import types
    import pprint

    def format_dict(d: dict):
        if not d: # dict is empty
            return '{}'
        indent = 2
        pretty = pprint.pformat(d, indent=indent, width=80)
        lines = pretty[1:-1].strip().split('\n')
        lines[0] = (' ' * indent) + lines[0] # add indent to first item
        formatted = '{\n' + '\n'.join(lines) + '\n}'
        return formatted

    lines = []
    for k, v in list(globals().items()):
        if (
            k.startswith('_')
            or k in ['In', 'Out', 'get_ipython', 'exit', 'quit', 'open', 'sys']
            or k in dir(__builtins__)
            or isinstance(v, (types.FunctionType, types.BuiltinFunctionType, types.MethodType))
        ):
            continue
        if isinstance(v, types.ModuleType):
            continue
        tname = type(v).__name__
        if isinstance(v, pd.DataFrame):
            lines.append(f"{k}: DataFrame {v.shape} =\n{v.head().to_string(index=False)}")
        elif isinstance(v, dict):
            pretty = format_dict(v)
            lines.append(f"{k}: dict = {pretty}")
        elif isinstance(v, list):
            preview = pprint.pformat(v, indent=2, width=80)
            lines.append(f"{k}: list = {preview}")
        else:
            lines.append(f"{k}: {tname} = {repr(v)}")
    print('\n\n'.join(lines), end='')

_molten_show_vars()
del _molten_show_vars
]]
		    vim.fn.MoltenEvaluateArgument(code, { on_done = "require('Or1g3n/plugins/molten-nvim').show_kernel_vars" })
		end, { desc = 'Molten: Show kernel variables' })
	    end,
	})

	-- Graceful error if Python provider is missing
	local function python_is_active()
	    if vim.fn.has('python3') == 0 then
		vim.notify(
		    "Molten.nvim: Python 3 provider not found. Don't forget to activate your virtual environment.",
		    vim.log.levels.ERROR,
		    { timeout = 5000 }
		)
		return false
	    else
		return true
	    end
	end

	-- Change the configuration when editing a python file
	vim.api.nvim_create_autocmd("BufEnter", {
	    pattern = "*.py",
	    callback = function(e)
		if python_is_active() == false then return end

		if string.match(e.file, ".otter.") then
		    return
		end
		if require("molten.status").initialized() == "Molten" then
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
		if python_is_active() == false then return end

		if string.match(e.file, ".otter.") then
		    return
		end

		local is_markdown = vim.bo.filetype == 'markdown'
		local tags = nil
		if is_markdown then
		    tags = cell_tags.markdown.python
		else
		    tags = cell_tags.non_markdown.python
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
		local function is_skip_line(line_num)
		    local line_text = vim.fn.getline(line_num)
		    local prev_line_text = vim.fn.getline(line_num - 1)
		    local next_line_text = vim.fn.getline(line_num + 1)
		    return
			(line_text == ''
			and prev_line_text:match('^' .. tags.cell_end .. '$') ~= nil
			and next_line_text:match('^' .. tags.cell_start .. '$') ~= nil)
			or line_text == tags.cell_start
			or (tags.cell_end ~= '' and line_text == tags.cell_end)
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
		    -- If next line is folded, use normal movement
		    if vim.fn.foldclosed(next_num) ~= -1 then
			return vim.cmd("normal! j")
		    end
		    if (next_num == max_num) and next_text == tags.cell_end then
			return
		    end
		    if vim.fn.searchpair('^' .. tags.cell_start .. '$','','^' .. tags.cell_end .. '$', 'ncbW') > 0 and next_text ~= tags.cell_end then
			return vim.cmd("normal! " .. "j")
		    end
		    while cur_num < max_num do
			cur_num = cur_num + 1
			if not is_skip_line(cur_num) then
			    break
			end
		    end
		    vim.api.nvim_win_set_cursor(0, { cur_num, 0 })
		end

		local function smart_up()
		    local count = vim.v.count
		    if count > 0 then
			return vim.cmd("normal! " .. count .. "k")
		    end
		    local cur_num = vim.fn.line(".")
		    local prev_num = cur_num - 1
		    local prev_text = vim.fn.getline(prev_num)
		    -- If previous line is folded, use normal movement
		    if vim.fn.foldclosed(prev_num) ~= -1 then
			return vim.cmd("normal! k")
		    end
		    if (prev_num == 1) and prev_text == tags.cell_start then
			return
		    end
		    if vim.fn.searchpair('^' .. tags.cell_start .. '$','','^' .. tags.cell_end .. '$', 'ncbW') > 0 and prev_text ~= tags.cell_start then
			return vim.cmd("normal! " .. "k")
		    end
		    while cur_num > 1 do
			cur_num = cur_num - 1
			if not is_skip_line(cur_num) then
			    break
			end
		    end
		    vim.api.nvim_win_set_cursor(0, { cur_num, 0 })
		end

		-- If jupyter notebook add smart up/down keymaps
		if vim.fn.expand('%:e') == 'ipynb' then
		    vim.keymap.set('n', 'j', smart_down, { buffer = true, desc = "Smart down (skip cell tags)" })
		    vim.keymap.set('n', 'k', smart_up,   { buffer = true, desc = "Smart up (skip cell tags)" })
		end

		-- Add keymaps for adding/removing new code blocks
		-- Add new block after current
		vim.keymap.set('n', '<A-n>',
		    function()
			local lines = {}
			local next_block_end = 0
			local is_empty = vim.fn.line('$') == 1 and vim.fn.getline(1) == ''
			if not is_empty then
			    if is_markdown then
				next_block_end = vim.fn.search("^" .. tags.cell_end .. '$', "cW")
				if next_block_end == 0 then
				    next_block_end = vim.fn.line("$")
				end
			    else
				local next_start = vim.fn.search("^" .. tags.cell_start, "W")
				if next_start == 0 then
				    next_block_end = vim.fn.line("$")
				else
				    next_block_end = next_start - 1
				end
			    end
			end
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
			vim.api.nvim_win_set_cursor(0, { next_block_end + #lines - 1, 0 })
		    end,
		    { buffer = true, desc = "Insert new Python code block after current", }
		)

		-- Add new block before current
		vim.keymap.set('n', '<A-b>',
		    function()
			local cur_line = vim.api.nvim_get_current_line()
			local prev_block_start = nil
			if cur_line:match("^" .. tags.cell_start) then
			    prev_block_start = vim.fn.line(".")
			else
			    prev_block_start = vim.fn.search("^" .. tags.cell_start, "b")
			end
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
			vim.api.nvim_win_set_cursor(0, { prev_block_start + 1, 0 })
		    end,
		    { buffer = true, desc = "Insert new Python code block before current" }
		)

		-- Delete block and move to prior
		vim.keymap.set('n', '<A-d><A-d>',
		    function()
			local multiplier = vim.v.count1
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
				    vim.cmd.normal("vabjd[b")
				else
				    vim.cmd.normal("vabokddd[b")
				end
			    else
				local cell_block = define_cell_block()
				if cell_block == nil then return end
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
    show_kernel_vars = show_kernel_vars
}
