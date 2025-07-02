return {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = "cd app; npm install",
    config = function()
	vim.g.mkdp_auto_start = 0      -- don't auto open browser
	vim.g.mkdp_auto_close = 1      -- auto-close preview when buffer is closed
	vim.g.mkdp_theme = "dark"

	-- Keymaps
	local map = vim.keymap -- for conciseness

	map.set('n', '<A-m><A-p>', ':MarkdownPreviewToggle<CR>', { noremap = true, silent = true, desc = "Markdown: Toggle preview" })
    end
}
