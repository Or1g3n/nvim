return {
    'mbbill/undotree',
    keys = {
	{ "<leader>ut", "<cmd>UndotreeToggle<CR>", desc = "UndoTree: Toggle" },
    },
    config = function()
	if vim.fn.has "win32" == 1 then -- only windows
	    vim.g.undotree_DiffCommand = vim.fn.stdpath('config') ..  "\\bin\\diff.exe"
	end
    end
}
