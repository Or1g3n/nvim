return {
    "akinsho/bufferline.nvim",
    enabled = true,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    version = "*",
    config = function()
	local bufferline = require('bufferline')

	bufferline.setup({
	    options = {
		mode = "buffers",
		offsets = {
		    {
			filetype = "NvimTree",
			text = "File Explorer",
			highlight = "Directory",
			separator = true -- use a "true" to enable the default, or set your own character
		    }
		},
		always_show_bufferline = false,
		auto_toggle_bufferline = false -- this allows manual setting of showtabline option
	    },
	})
    end
}
