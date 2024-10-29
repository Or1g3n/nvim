return {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
    config = function()
	local map = vim.keymap

	-- Set keymaps
	map.set('n','<A-m><A-r>',':RenderMarkdown toggle<CR>', { noremap = true, silent = true, desc = 'Markdown: render markdown' })
    end
}
