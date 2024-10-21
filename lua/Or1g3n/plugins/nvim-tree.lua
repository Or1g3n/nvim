return {
    "nvim-tree/nvim-tree.lua",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
	local nvimtree = require("nvim-tree")

	-- Disable netrw and override
	vim.g.loaded_netrw = 1
	vim.g.loaded_netrwPlugin = 1

	nvimtree.setup({
	    view = {
		side = "left",
		width = 35,
		relativenumber = true,
	    },
	    renderer = {
		indent_markers = {
		    enable = true,
		},
		highlight_git = "all",
	    },
	})

	-- set keymaps
	local map = vim.keymap -- for conciseness
	local api = require("nvim-tree.api")

	map.set("n", "<leader>ee", ":NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
	map.set("n", "<leader>ef", ":NvimTreeFindFileToggle<CR>", { desc = "Toggle file explorer on current file" })
	map.set("n", "<leader>er", ":NvimTreeRefresh<CR>", { desc = "Refresh file explorer" })
	map.set("n", "<leader>er", ":NvimTreeRefresh<CR>", { desc = "Refresh file explorer" })
    end
}
