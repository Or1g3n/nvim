return {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "BufNewFile" },
    build = ":TSUpdate",
    dependencies = {
	"windwp/nvim-ts-autotag",
    },
    config = function()
	-- import nvim-treesitter plugin
	local treesitter = require("nvim-treesitter.configs")

	-- configure treesitter
	treesitter.setup({ -- enable syntax highlighting
	    auto_install = true,
	    sync_install = false,
	    ignore_install = {},
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
		"vim",
		"vimdoc",
		"yaml",
	    },
	    --    incremental_selection = {
	    -- enable = true,
	    -- keymaps = {
	    --     init_selection = "<C-space>",
	    --     node_incremental = "<C-space>",
	    --     scope_incremental = false,
	    --     node_decremental = "<bs>",
	    -- },
	    --    },
	})
    end,
}
