return {
    "quarto-dev/quarto-nvim",
    dependencies = {
	"jmbuhr/otter.nvim",
	"nvim-treesitter/nvim-treesitter",
    },
    ft = {"quarto", "markdown"},
    config = function()
	local quarto = require("quarto")
	quarto.setup({
	    lspFeatures = {
		-- NOTE: put whatever languages you want here:
		languages = { "python" },
		chunks = "all",
		diagnostics = {
		    enabled = true,
		    triggers = { "BufWritePost" },
		},
		completion = {
		    enabled = true,
		},
	    },
	    keymap = {
		hover = "K",
		definition = "gd",
		rename = "<leader>rn",
		references = "gr",
		format = "<leader>gf",
	    },
	    codeRunner = {
		enabled = true,
		default_method = "molten",
	    },
	})
    end
}
