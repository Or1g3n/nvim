return {
    "folke/snacks.nvim",
    opts = {
	dashboard = {
	    enabled = false,
	    width = 60,
	    row = nil, -- dashboard position. nil for center
	    col = nil, -- dashboard position. nil for center
	    pane_gap = 4, -- empty columns between vertical panes
	    autokeys = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ", -- autokey sequence
	    -- These settings are used by some built-in sections
	    preset = {
		-- Defaults to a picker that supports `fzf-lua`, `telescope.nvim` and `mini.pick`
		pick = nil,
		-- Used by the `keys` section to show keymaps.
		-- Set your custom keymaps here.
		-- When using a function, the `items` argument are the default keymaps.
		keys = {
		    { icon = " ", key = "o",  desc = "Open last session", action = ":source ~/.nvim-sessions/session.vim" }, -- Note this assumes that vim-obsession config exists with global session_file defined
		    { icon = " ", key = "n",  desc = "New file", action = ":enew | startinsert" },
		    { icon = "󰈞 ", key = "f",  desc = "Find file", action = ":lua Snacks.picker.files()" },
		    { icon = "󰈢 ", key = "r",  desc = "Recent files", action = ":lua Snacks.picker.recent()" },
		    { icon = " ", key = "e",  desc = "Open explorer", action = ":lua require('mini.files').open()" },
		    { icon = " ", key = "h",  desc = "Open help search", action = ":lua Snacks.picker.help()" }, -- Note this assumes that vim-obsession config exists with global session_file defined
		    { icon = " ", key = "t",  desc = "Open todos list", action = ":MarkdownUpdateTodos" }, -- Note this assumes that vim-obsession config exists with global session_file defined
		    { icon = " ", key = "sc", desc = "Search config files", action = ":lua Snacks.picker.files({ cwd= vim.fn.stdpath('config') })" },
		    { icon = " ", key = "cm", desc = "Show commands", action = ":lua Snacks.picker.commands()" },
		    { icon = " ", key = "?",  desc = "Show keymaps", action = ":lua Snacks.picker.keymaps()" },
		    { icon = " ", key = "cs", desc = "Change color-scheme", action = ":lua Snacks.picker.colorschemes()" },
		    { icon = "󰒲 ", key = "l",  desc = "Open lazy package manager", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
		    { icon = "󱌢 ", key = "m",  desc = "Open mason lsp manager", action = ":Mason" },
		    { icon = "󰩈 ", key = "q",  desc = "Quit Neovim", action = ":qa" },
		},
		-- Used by the `header` section
		header = [[
					                           
      ████ ██████           █████      ██                    
     ███████████             █████                            
     █████████ ███████████████████ ███   ███████████  
    █████████  ███    █████████████ █████ ██████████████  
   █████████ ██████████ █████████ █████ █████ ████ █████  
 ███████████ ███    ███ █████████ █████ █████ ████ █████ 
██████  █████████████████████ ████ █████ █████ ████ ██████
								       ]]
	    },
	    -- item field formatters
	    formats = {
		icon = function(item)
		    if item.file and item.icon == "file" or item.icon == "directory" then
			return M.icon(item.file, item.icon)
		    end
		    return { item.icon, width = 2, hl = "icon" }
		end,
		footer = { "%s", align = "center" },
		header = { "%s", align = "center" },
		file = function(item, ctx)
		    local fname = vim.fn.fnamemodify(item.file, ":~")
		    fname = ctx.width and #fname > ctx.width and vim.fn.pathshorten(fname) or fname
		    if #fname > ctx.width then
			local dir = vim.fn.fnamemodify(fname, ":h")
			local file = vim.fn.fnamemodify(fname, ":t")
			if dir and file then
			    file = file:sub(-(ctx.width - #dir - 2))
			    fname = dir .. "/…" .. file
			end
		    end
		    local dir, file = fname:match("^(.*)/(.+)$")
		    return dir and { { dir .. "/", hl = "dir" }, { file, hl = "file" } } or { { fname, hl = "file" } }
		end,
	    },
	    sections = {
		{ section = "header" },
		{ section = "keys", gap = 1, padding = 1 },
		{ section = "startup" },
	    },
	}
    },
    keys = {
	{ mode = 'n', "<A-a>", function() Snacks.dashboard() end, desc = "snacks.dashboard: Open dashboard" },
    }
}
