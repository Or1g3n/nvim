local function get_build_cmd()
    if vim.o.shell == "nu" then
	return "cd app; npm install"
    elseif vim.loop.os_uname().version:match("Windows") then
	return "cd app & npm install"
    else
	return "cd app && npm install"
    end
end

return {
    "iamcco/markdown-preview.nvim",
    enabled = true,
    -- enabled = false,
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = get_build_cmd(),
    config = function()
	vim.g.mkdp_auto_start = 0
	vim.g.mkdp_auto_close = 1
	vim.g.mkdp_theme = "dark"
	vim.keymap.set('n', '<A-m><A-p>', ':MarkdownPreviewToggle<CR>', { noremap = true, silent = true, desc = "Markdown: Toggle preview" })
    end,
}
