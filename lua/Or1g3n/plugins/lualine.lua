return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
	local lualine = require("lualine")
	local lazy_status = require("lazy.status") -- to configure lazy pending updates count

	lualine.setup({
	    options = {
		disabled_filetypes = {
		    statusline = {
			'NvimTree',
			'alpha',
			'dashboard',
			"ministarter",
			"snacks_dashboard",
		    }
		},
		ignore_focus = {
		    'NvimTree',
		    'dap-repl',
		    'dapui_console',
		    'dapui_scopes',
		    'dapui_breakpoints',
		    'dapui_stacks',
		    'dapui_watches',
		    'dapui_hover',
		},
	    }
	})

	-- Auto-refresh lualine theme on colorscheme change
	-- vim.cmd [[
	--     augroup LualineColorscheme
	--     autocmd!
	--     autocmd ColorScheme * lua require('lualine').setup { options = { theme = vim.g.colors_name } }
	--     augroup END
	-- ]]
    end,
}
