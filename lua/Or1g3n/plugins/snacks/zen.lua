return    {
    "folke/snacks.nvim",
    enabled = true,
    opts = {
	styles = {
	    zen = {
		enter = true,
		fixbuf = false,
		minimal = false,
		width = 220,
		height = 0,
		backdrop = { transparent = true, blend = 40 },
		keys = { q = false },
	    }
	},
	zen = {
	    toggles = {
		dim = false,
		git_signs = false,
		mini_diff_signs = false,
		-- diagnostics = false,
		-- inlay_hints = false,
	    },
	    show = {
		statusline = true, -- can only be shown when using the global statusline
		tabline = true,
	    },
	}
    },
    keys = {
	{ "<leader>z",  function() Snacks.zen() end, desc = "Snacks: Toggle Zen Mode" },
	{ "<leader>Z",  function() Snacks.zen.zoom() end, desc = "Snacks: Toggle Zoom" },
    },
}
