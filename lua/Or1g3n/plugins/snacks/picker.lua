return {
    "folke/snacks.nvim",
    enabled = true,
    config = function()
	local snacks = require('snacks')

	snacks.picker.setup({
	    prompt = " ",
	    sources = {},
	    layout = {
		cycle = true,
		--- Use the default layout or vertical if the window is too narrow
		preset = function()
		    return vim.o.columns >= 120 and "default" or "vertical"
		end,
	    },
	    ---@class snacks.picker.matcher.Config
	    matcher = {
		fuzzy = true, -- use fuzzy matching
		smartcase = true, -- use smartcase
		ignorecase = true, -- use ignorecase
		sort_empty = false, -- sort results when the search string is empty
		filename_bonus = true, -- give bonus for matching file names (last part of the path)
		file_pos = true, -- support patterns like `file:line:col` and `file:line`
	    },
	    sort = {
		-- default sort is by score, text length and index
		fields = { "score:desc", "#text", "idx" },
	    },
	    ui_select = true, -- replace `vim.ui.select` with the snacks picker
	    ---@class snacks.picker.formatters.Config
	    formatters = {
		file = {
		    filename_first = false, -- display filename before the file path
		},
		selected = {
		    show_always = false, -- only show the selected column when there are multiple selections
		    unselected = true, -- use the unselected icon for unselected items
		},
	    },
	    ---@class snacks.picker.previewers.Config
	    previewers = {
		git = {
		    native = false, -- use native (terminal) or Neovim for previewing git diffs and commits
		},
		file = {
		    max_size = 1024 * 1024, -- 1MB
		    max_line_length = 500, -- max line length
		    ft = nil, ---@type string? filetype for highlighting. Use `nil` for auto detect
		},
		man_pager = nil, ---@type string? MANPAGER env to use for `man` preview
	    },
	    ---@class snacks.picker.jump.Config
	    jump = {
		jumplist = true, -- save the current position in the jumplist
		tagstack = false, -- save the current position in the tagstack
		reuse_win = false, -- reuse an existing window if the buffer is already open
	    },
	    win = {
		-- input window
		input = {
		    keys = {
			["<Esc>"] = "close",
			["<C-c>"] = { "close", mode = "i" },
			-- to close the picker on ESC instead of going to normal mode,
			-- add the following keymap to your config
			-- ["<Esc>"] = { "close", mode = { "n", "i" } },
			["<CR>"] = { "confirm", mode = { "n", "i" } },
			["G"] = "list_bottom",
			["gg"] = "list_top",
			["j"] = "list_down",
			["k"] = "list_up",
			["/"] = "toggle_focus",
			["q"] = "close",
			["?"] = "toggle_help",
			["<a-d>"] = { "inspect", mode = { "n", "i" } },
			["<c-a>"] = { "select_all", mode = { "n", "i" } },
			["<a-m>"] = { "toggle_maximize", mode = { "i", "n" } },
			["<a-p>"] = { "toggle_preview", mode = { "i", "n" } },
			["<a-w>"] = { "cycle_win", mode = { "i", "n" } },
			["<C-w>"] = { "<c-s-w>", mode = { "i" }, expr = true, desc = "delete word" },
			["<C-Up>"] = { "history_back", mode = { "i", "n" } },
			["<C-Down>"] = { "history_forward", mode = { "i", "n" } },
			["<Tab>"] = { "select_and_next", mode = { "i", "n" } },
			["<S-Tab>"] = { "select_and_prev", mode = { "i", "n" } },
			["<Down>"] = { "list_down", mode = { "i", "n" } },
			["<Up>"] = { "list_up", mode = { "i", "n" } },
			["<c-j>"] = { "list_down", mode = { "i", "n" } },
			["<c-k>"] = { "list_up", mode = { "i", "n" } },
			["<c-n>"] = { "list_down", mode = { "i", "n" } },
			["<c-p>"] = { "list_up", mode = { "i", "n" } },
			["<c-b>"] = { "preview_scroll_up", mode = { "i", "n" } },
			["<c-d>"] = { "list_scroll_down", mode = { "i", "n" } },
			["<c-f>"] = { "preview_scroll_down", mode = { "i", "n" } },
			["<c-g>"] = { "toggle_live", mode = { "i", "n" } },
			["<c-u>"] = { "list_scroll_up", mode = { "i", "n" } },
			["<ScrollWheelDown>"] = { "list_scroll_wheel_down", mode = { "i", "n" } },
			["<ScrollWheelUp>"] = { "list_scroll_wheel_up", mode = { "i", "n" } },
			["<c-v>"] = { "edit_vsplit", mode = { "i", "n" } },
			["<c-s>"] = { "edit_split", mode = { "i", "n" } },
			["<c-q>"] = { "qflist", mode = { "i", "n" } },
			["<a-i>"] = { "toggle_ignored", mode = { "i", "n" } },
			["<a-h>"] = { "toggle_hidden", mode = { "i", "n" } },
			["<a-f>"] = { "toggle_follow", mode = { "i", "n" } },
		    },
		    b = {
			minipairs_disable = true,
		    },
		},
		-- result list window
		list = {
		    keys = {
			["<CR>"] = "confirm",
			["gg"] = "list_top",
			["G"] = "list_bottom",
			["i"] = "focus_input",
			["j"] = "list_down",
			["k"] = "list_up",
			["q"] = "close",
			["<Tab>"] = "select_and_next",
			["<S-Tab>"] = "select_and_prev",
			["<Down>"] = "list_down",
			["<Up>"] = "list_up",
			["<a-d>"] = "inspect",
			["<c-d>"] = "list_scroll_down",
			["<c-u>"] = "list_scroll_up",
			["zt"] = "list_scroll_top",
			["zb"] = "list_scroll_bottom",
			["zz"] = "list_scroll_center",
			["/"] = "toggle_focus",
			["<ScrollWheelDown>"] = "list_scroll_wheel_down",
			["<ScrollWheelUp>"] = "list_scroll_wheel_up",
			["<c-a>"] = "select_all",
			["<c-f>"] = "preview_scroll_down",
			["<c-b>"] = "preview_scroll_up",
			["<c-v>"] = "edit_vsplit",
			["<c-s>"] = "edit_split",
			["<c-j>"] = "list_down",
			["<c-k>"] = "list_up",
			["<c-n>"] = "list_down",
			["<c-p>"] = "list_up",
			["<a-w>"] = "cycle_win",
			["<Esc>"] = "close",
		    },
		    wo = {
			conceallevel = 2,
			concealcursor = "nvc",
		    },
		},
		-- preview window
		preview = {
		    keys = {
			["<Esc>"] = "close",
			["q"] = "close",
			["i"] = "focus_input",
			["<ScrollWheelDown>"] = "list_scroll_wheel_down",
			["<ScrollWheelUp>"] = "list_scroll_wheel_up",
			["<a-w>"] = "cycle_win",
		    },
		},
	    },
	    ---@class snacks.picker.icons
	    icons = {
		files = {
		    enabled = true, -- show file icons
		},
		indent = {
		    vertical    = "│ ",
		    middle = "├╴",
		    last   = "└╴",
		},
		undo = {
		    saved   = " ",
		},
		ui = {
		    live        = "󰐰 ",
		    hidden      = "h",
		    ignored     = "i",
		    follow      = "f",
		    selected    = "● ",
		    unselected  = "○ ",
		    -- selected = " ",
		},
		git = {
		    commit = "󰜘 ",
		},
		diagnostics = {
		    Error = " ",
		    Warn  = " ",
		    Hint  = " ",
		    Info  = " ",
		},
		kinds = {
		    Array         = " ",
		    Boolean       = "󰨙 ",
		    Class         = " ",
		    Color         = " ",
		    Control       = " ",
		    Collapsed     = " ",
		    Constant      = "󰏿 ",
		    Constructor   = " ",
		    Copilot       = " ",
		    Enum          = " ",
		    EnumMember    = " ",
		    Event         = " ",
		    Field         = " ",
		    File          = " ",
		    Folder        = " ",
		    Function      = "󰊕 ",
		    Interface     = " ",
		    Key           = " ",
		    Keyword       = " ",
		    Method        = "󰊕 ",
		    Module        = " ",
		    Namespace     = "󰦮 ",
		    Null          = " ",
		    Number        = "󰎠 ",
		    Object        = " ",
		    Operator      = " ",
		    Package       = " ",
		    Property      = " ",
		    Reference     = " ",
		    Snippet       = "󱄽 ",
		    String        = " ",
		    Struct        = "󰆼 ",
		    Text          = " ",
		    TypeParameter = " ",
		    Unit          = " ",
		    Unknown        = " ",
		    Value         = " ",
		    Variable      = "󰀫 ",
		},
	    },
	    ---@class snacks.picker.debug
	    debug = {
		scores = false, -- show scores in the list
		leaks = false, -- show when pickers don't get garbage collected
	    },
	})

	-- set keymaps
	local map = vim.keymap

	map.set('n', "<leader>,", function() snacks.picker.buffers() end, { desc = "snacks.picker: Find Buffers" })
	map.set('n', "<leader>/", function() snacks.picker.grep() end, { desc = "snacks.picker: Find Grep" })
	map.set('n', "<leader>:", function() snacks.picker.command_history() end, { desc = "snacks.picker: Search Command History" })
	map.set('n', "<leader><space>", function() snacks.picker.files() end, { desc = "snacks.picker: Find Files" })
	-- find files
	map.set('n', "<leader>fb", function() snacks.picker.buffers() end, { desc = "snacks.picker: Find Buffers" })
	map.set('n', "<leader>fc", function() snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, { desc = "snacks.picker: Find Config File" })
	map.set('n', "<leader>ff", function() snacks.picker.files() end, { desc = "snacks.picker: Find Files" })
	map.set('n', "<leader>fg", function() snacks.picker.git_files() end, { desc = "snacks.picker: Find Git Files" })
	map.set('n', "<leader>fr", function() snacks.picker.recent() end, { desc = "snacks.picker: Find Recent" })
	-- git
	map.set('n', "<leader>gl", function() snacks.picker.git_log() end, { desc = "snacks.picker: Git Log" })
	map.set('n', "<leader>gs", function() snacks.picker.git_status() end, { desc = "snacks.picker: Git Status" })
	-- Grep
	map.set('n', "<leader>sb", function() snacks.picker.lines() end, { desc = "snacks.picker: Search Buffer Lines" })
	map.set('n', "<leader>sB", function() snacks.picker.grep_buffers() end, { desc = "snacks.picker: Grep Open Buffers" })
	map.set('n', "<leader>sg", function() snacks.picker.grep() end, { desc = "snacks.picker: Grep" })
	map.set('n', "<leader>sw", function() snacks.picker.grep_word() end, { desc = "snacks.picker: Search Visual selection or word" })
	map.set('x', "<leader>sw", function() snacks.picker.grep_word() end, { desc = "snacks.picker: Search Visual selection or word" })
	-- search contents
	map.set('n', '<leader>s"', function() snacks.picker.registers() end, { desc = "snacks.picker: Search Registers" })
	map.set('n', "<leader>sa", function() snacks.picker.autocmds() end, { desc = "snacks.picker: Search Autocmds" })
	map.set('n', "<leader>sc", function() snacks.picker.command_history() end, { desc = "snacks.picker: Search Command History" })
	map.set('n', "<leader>sC", function() snacks.picker.commands() end, { desc = "snacks.picker: Search Commands" })
	map.set('n', "<leader>sd", function() snacks.picker.diagnostics() end, { desc = "snacks.picker: Search Diagnostics" })
	map.set('n', "<leader>sh", function() snacks.picker.help() end, { desc = "snacks.picker: Search Help Pages" })
	map.set('n', "<leader>sH", function() snacks.picker.highlights() end, { desc = "snacks.picker: Search Highlights" })
	map.set('n', "<leader>sj", function() snacks.picker.jumps() end, { desc = "snacks.picker: Search Jumps" })
	map.set('n', "<leader>sk", function() snacks.picker.keymaps() end, { desc = "snacks.picker: Search Keymaps" })
	map.set('n', "<leader>sl", function() snacks.picker.loclist() end, { desc = "snacks.picker: Search Location List" })
	map.set('n', "<leader>sM", function() snacks.picker.man() end, { desc = "snacks.picker: Search Man Pages" })
	map.set('n', "<leader>sm", function() snacks.picker.marks() end, { desc = "snacks.picker: Search Marks" })
	map.set('n', "<leader>sR", function() snacks.picker.resume() end, { desc = "snacks.picker: Search Resume" })
	map.set('n', "<leader>sq", function() snacks.picker.qflist() end, { desc = "snacks.picker: Search Quickfix List" })
	map.set('n', "<leader>uC", function() snacks.picker.colorschemes() end, { desc = "snacks.picker: Search Colorschemes" })
	map.set('n', "<leader>qp", function() snacks.picker.projects() end, { desc = "snacks.picker: Search Projects" })
	-- LSP
	map.set('n', "gd", function() snacks.picker.lsp_definitions() end, { desc = "LSP: Goto Definition" })
	map.set('n', "gr", function() snacks.picker.lsp_references() end, { desc = "LSP: Search References", nowait = true })
	map.set('n', "gI", function() snacks.picker.lsp_implementations() end, { desc = "LSP: Goto Implementation" })
	map.set('n', "gy", function() snacks.picker.lsp_type_definitions() end, { desc = "LSP: Goto T[y]pe Definition" })
	map.set('n', "<leader>ss", function() snacks.picker.lsp_symbols() end, { desc = "LSP: Search LSP Symbols" })

    end
}
