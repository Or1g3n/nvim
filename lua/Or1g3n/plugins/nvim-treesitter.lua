return {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "BufNewFile" },
    build = ":TSUpdate",
    dependencies = {
	"windwp/nvim-ts-autotag",
	{"nushell/tree-sitter-nu", build = ":TSUpdate nu"},
    },
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
	})
    end,
}
