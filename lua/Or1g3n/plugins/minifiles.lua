return{
    'echasnovski/mini.files',
    version = false,
    enabled = true,
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function ()
	local minifiles = require('mini.files')

	minifiles.setup(
	    -- No need to copy this inside `setup()`. Will be used automatically.
	    {
		-- Customization of shown content
		content = {
		    -- Predicate for which file system entries to show
		    filter = nil,
		    -- What prefix to show to the left of file system entry
		    prefix = nil,
		    -- In which order to show file system entries
		    sort = nil,
		},

		-- Module mappings created only inside explorer.
		-- Use `''` (empty string) to not create one.
		mappings = {
		    close       = 'q',
		    go_in       = 'l',
		    go_in_plus  = '<CR>',
		    go_out      = 'h',
		    go_out_plus = 'H',
		    mark_goto   = "'",
		    mark_set    = 'm',
		    reset       = '<BS>',
		    reveal_cwd  = '@',
		    show_help   = 'g?',
		    synchronize = '=',
		    trim_left   = '<',
		    trim_right  = '>',
		},

		-- General options
		options = {
		    -- Whether to delete permanently or move into module-specific trash
		    permanent_delete = true,
		    -- Whether to use for editing directories
		    use_as_default_explorer = true,
		},

		-- Customization of explorer windows
		windows = {
		    -- Maximum number of windows to show side by side
		    max_number = math.huge,
		    -- Whether to show preview of file/directory under cursor
		    preview = false,
		    -- Width of focused window
		    width_focus = 50,
		    -- Width of non-focused window
		    width_nofocus = 15,
		    -- Width of preview window
		    width_preview = 25,
		},
	    }
	)

	-- Custom Functions
	-- Open buffers in split or tab
	local map_open = function(buf_id, lhs, action, direction)
	    local rhs = function()
		if action == "split" then
		    -- Get the current target window
		    local cur_target = minifiles.get_explorer_state().target_window
		    -- Create a new split and get its window ID
		    local new_target = vim.api.nvim_win_call(cur_target, function()
			vim.cmd(direction .. ' split')
			return vim.api.nvim_get_current_win()
		    end)
		    -- Set the new target window
		    minifiles.set_target_window(new_target)
		    -- Open the file in the new split
		    minifiles.go_in()
		elseif action == "tab" then
		    -- Get file path for explorer entry
		    local file_path = minifiles.get_fs_entry().path
		    -- Close explorer
		    minifiles.close()
		    -- Open the file in a new tab
		    vim.cmd('tabnew ' .. vim.fn.fnameescape(file_path))
		    -- Open explorer in new tab
		    minifiles.open(vim.api.nvim_buf_get_name(0), true)
		end
	    end

	    -- Map the key with a description
	    local desc = action == "split" and ('Split ' .. direction) or 'Open in new tab'
	    vim.keymap.set('n', lhs, rhs, { buffer = buf_id, desc = desc })
	end

	-- Set focused directory as current working directory
	local set_cwd = function()
	    local path = (MiniFiles.get_fs_entry() or {}).path
	    if path == nil then
		return vim.notify('Cursor is not on valid entry')
	    end
	    vim.fn.chdir(vim.fs.dirname(path))
	end

	-- Yank in register full path of entry under cursor
	local yank_path = function()
	    local path = (MiniFiles.get_fs_entry() or {}).path
	    if path == nil then
		return vim.notify('Cursor is not on valid entry')
	    end
	    vim.fn.setreg(vim.v.register, path)
	end

	-- Keymaps
	local map = vim.keymap

	-- Mini.files only keymaps
	vim.api.nvim_create_autocmd('User', {
	    pattern = 'MiniFilesBufferCreate',
	    callback = function(args)
		local buf_id = args.data.buf_id
		-- Map keys for horizontal and vertical splits
		map_open(buf_id, '<Leader>s', 'split', 'belowright horizontal')
		map_open(buf_id, '<Leader>v', 'split', 'belowright vertical')
		-- Map key for opening in a new tab
		map_open(buf_id, '<Leader>t', 'tab')
		-- Map key for preview toggle
		map.set('n', '<C-p>',function() MiniFiles.config.windows.preview = not MiniFiles.config.windows.preview end, { buffer = buf_id, desc = 'Toggle file preview' })
		-- Map key for change cwd
		map.set('n', 'g@', set_cwd,   { buffer = buf_id, desc = 'Set cwd' })
		-- Map key for yank file path
		map.set('n', 'gy', yank_path, { buffer = buf_id, desc = 'Yank path' })
	    end,
	})

	-- Global keymaps
	map.set('n', '<Leader>e', function () minifiles.open(vim.api.nvim_buf_get_name(0), true) end, { noremap = true, silent = true, desc = "Mini Files: Open file explorer (file directory)" })
	map.set('n', '<Leader>E', function () minifiles.open() end, { noremap = true, silent = true, desc = "Mini Files: Open file explorer (cwd)" })

	-- Set pre-built bookmarks
	local set_mark = function(id, path, desc)
	    MiniFiles.set_bookmark(id, path, { desc = desc })
	end
	vim.api.nvim_create_autocmd('User', {
	    pattern = 'MiniFilesExplorerOpen',
	    callback = function()
		set_mark('c', vim.fn.stdpath('config'), 'Config') -- path
		set_mark('n', vim.fn.stdpath('data'), 'Nvim-Data') -- path
		set_mark('w', vim.fn.getcwd(), 'Working directory') -- callable
		set_mark('~', '~', 'Home directory')
		set_mark('r', '~/repos', 'Repos directory')
	    end,
	})
    end
}
