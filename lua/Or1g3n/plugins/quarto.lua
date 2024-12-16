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
		languages = { "python", "lua" },
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

	local runner = require("quarto.runner")

	vim.keymap.set("n", "<leader>xc", runner.run_cell,  { desc = "Quarto: run cell", silent = true })
	vim.keymap.set("n", "<leader>xu", runner.run_above, { desc = "Quarto: run cell and above", silent = true })
	vim.keymap.set("n", "<leader>xa", runner.run_all,   { desc = "Quarto: run all cells", silent = true })
	vim.keymap.set("n", "<leader>xl", runner.run_line,  { desc = "Quarto: run line", silent = true })
	vim.keymap.set("v", "<leader>x",  runner.run_range, { desc = "Quarto: run visual range", silent = true })
	vim.keymap.set("n", "<leader>XA", function() runner.run_all(true) end, { desc = "Quarto: run all cells of all languages", silent = true })
    end
}
