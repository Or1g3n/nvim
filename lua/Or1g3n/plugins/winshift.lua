return{
    'sindrets/winshift.nvim',
    config = function()
	local winshift = require('winshift')

	winshift.setup({
	    highlight_moving_win = true,  -- Highlight the window being moved
	    focused_hl_group = "Visual",  -- The highlight group used for the moving window
	    moving_win_options = {
		-- These are local options applied to the moving window while it's
		-- being moved. They are unset when you leave Win-Move mode.
		wrap = false,
		cursorline = false,
		cursorcolumn = false,
		colorcolumn = "",
	    },
	    keymaps = {
		disable_defaults = false, -- Disable the default keymaps
		win_move_mode = {
		    ["h"] = "left",
		    ["j"] = "down",
		    ["k"] = "up",
		    ["l"] = "right",
		    ["H"] = "far_left",
		    ["J"] = "far_down",
		    ["K"] = "far_up",
		    ["L"] = "far_right",
		    ["<left>"] = "left",
		    ["<down>"] = "down",
		    ["<up>"] = "up",
		    ["<right>"] = "right",
		    ["<S-left>"] = "far_left",
		    ["<S-down>"] = "far_down",
		    ["<S-up>"] = "far_up",
		    ["<S-right>"] = "far_right",
		},
	    },
	    ---A function that should prompt the user to select a window.
	    ---
	    ---The window picker is used to select a window while swapping windows with
	    ---`:WinShift swap`.
	    ---@return integer? winid # Either the selected window ID, or `nil` to
	    ---   indicate that the user cancelled / gave an invalid selection.
	    window_picker = function()
		return require('winshift.lib').pick_window({
		    -- A string of chars used as identifiers by the window picker.
		    picker_chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
		    filter_rules = {
			-- This table allows you to indicate to the window picker that a window
			-- should be ignored if its buffer matches any of the following criteria.
			cur_win = true, -- Filter out the current window
			floats = true,  -- Filter out floating windows
			filetype = {},  -- List of ignored file types
			buftype = {},   -- List of ignored buftypes
			bufname = {},   -- List of vim regex patterns matching ignored buffer names
		    },
		    ---A function used to filter the list of selectable windows.
		    ---@param winids integer[] # The list of selectable window IDs.
		    ---@return integer[] filtered # The filtered list of window IDs.
		    filter_func = nil,
		})
	    end,
	})

	-- Keymaps
	local map = vim.keymap
	-- Window-move mode and swap
	map.set('n', '<A-w><A-s>', ':WinShift<CR>', { noremap = true, silent = true, desc = "WinShift: Start window-move mode" })
	map.set('n', '<A-w><A-x>', ':WinShift swap<CR>', { noremap = true, silent = true, desc = "WinShift: Swap two windows" })
	-- Move left, right, up, down
	map.set('n', '<Leader>h', ':WinShift left<CR>', { noremap = true, silent = true, desc = "WinShift: Move window left" })
	map.set('n', '<Leader>l', ':WinShift right<CR>', { noremap = true, silent = true, desc = "WinShift: Move window right" })
	map.set('n', '<Leader>j', ':WinShift down<CR>', { noremap = true, silent = true, desc = "WinShift: Move window down" })
	map.set('n', '<Leader>k', ':WinShift up<CR>', { noremap = true, silent = true, desc = "WinShift: Move window up" })
	-- Move far-left, far-right, far-up, far-down
	map.set('n', '<Leader>H', ':WinShift far_left<CR>', { noremap = true, silent = true, desc = "WinShift: Move window far-left" })
	map.set('n', '<Leader>L', ':WinShift far_right<CR>', { noremap = true, silent = true, desc = "WinShift: Move window far-right" })
	map.set('n', '<Leader>J', ':WinShift far_down<CR>', { noremap = true, silent = true, desc = "WinShift: Move window far-down" })
	map.set('n', '<Leader>K', ':WinShift far_up<CR>', { noremap = true, silent = true, desc = "WinShift: Move window far-up" })
    end
}
