return {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
	"windwp/nvim-ts-autotag",
	"nvim-treesitter/nvim-treesitter-textobjects",
    },
    build = ":TSUpdate",
    config = function()
	-- import nvim-treesitter plugin
	local treesitter = require("nvim-treesitter.configs")

	-- configure treesitter
	treesitter.setup({ -- enable syntax highlighting
	    auto_install = false,
	    sync_install = false,
	    ignore_install = {},
	    modules = {},
	    highlight = {
		enable = true,
	    },
	    -- enable indentation
	    indent = {
		enable = true
	    },
	    -- enable autotagging (w/ nvim-ts-autotag plugin)
	    autotag = {
		enable = true,
	    },
	    -- ensure these language parsers are installed
	    ensure_installed = {
		"bash",
		"c",
		"css",
		"dockerfile",
		"gitignore",
		"graphql",
		"html",
		"json",
		"lua",
		"markdown",
		"markdown_inline",
		"nu",
		"python",
		"query",
		"sql",
		"vim",
		"vimdoc",
		"yaml",
	    },
	    incremental_selection = {
		enable = true,
		keymaps = {
		    -- init_selection = "<C-space>",
		    -- node_incremental = "<C-space>",
		    -- scope_incremental = false,
		    -- node_decremental = "<bs>",
		},
	    },
	    textobjects = {
		move = {
		    enable = true,
		    set_jumps = false, -- you can change this if you want.
		    goto_next_start = {
			--- ... other keymaps
			["]b"] = { query = "@code_cell.inner", desc = "TS Custom: next code block" },
			["<M-PageDown>"] = { query = "@code_cell.inner", desc = "TS Custom: next code block" },
		    },
		    goto_previous_start = {
			--- ... other keymaps
			["[b"] = { query = "@code_cell.inner", desc = "TS Custom: previous code block" },
			["<M-PageUp>"] = { query = "@code_cell.inner", desc = "TS Custom: previous code block" },
		    },
		},
		select = {
		    enable = true,
		    lookahead = true, -- you can change this if you want
		    keymaps = {
			--- ... other keymaps
			["ib"] = { query = "@code_cell.inner", desc = "TS Custom: in code block" },
			["ab"] = { query = "@code_cell.outer", desc = "TS Custom: around code block" },
		    },
		},
		-- swap = { -- Swap only works with code blocks that are under the same
		--     -- markdown header
		--     enable = true,
		--     swap_next = {
		-- 	--- ... other keymap
		-- 	["<leader>sbl"] = "@code_cell.outer",
		--     },
		--     swap_previous = {
		-- 	--- ... other keymap
		-- 	["<leader>sbh"] = "@code_cell.outer",
		--     },
		-- },
	    },
	})

	-- Set fold options
	vim.opt.foldmethod = 'expr'
	vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
    end,
}
