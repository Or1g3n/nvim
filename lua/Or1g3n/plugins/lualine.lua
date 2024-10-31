return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
	local lualine = require("lualine")
	local lazy_status = require("lazy.status") -- to configure lazy pending updates count

	lualine.setup({
		--    options = {
		-- -- theme = my_lualine_theme,
		-- theme = 'catppuccin',
		--    },
		--    sections = {
		-- lualine_x = {
		--     {
		-- 	lazy_status.updates,
		-- 	cond = lazy_status.has_updates,
		-- 	color = { fg = "#ff9e64" },
		--     },
		--     { "encoding" },
		--     { "fileformat" },
		--     { "filetype" },
		-- },
		--    },
	})

	-- Auto-refresh lualine theme on colorscheme change
	vim.cmd [[
	augroup LualineColorscheme
	autocmd!
	autocmd ColorScheme * lua require('lualine').setup { options = { theme = vim.g.colors_name } }
	augroup END
	]]
    end,
}
