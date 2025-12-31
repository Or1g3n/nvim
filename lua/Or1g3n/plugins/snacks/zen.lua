return    {
    "folke/snacks.nvim",
    enabled = true,
    opts = {
	styles = {
	    zen = {
		enter = true,
		fixbuf = false,
		minimal = false,
                width = function()
                    -- Set width to 80% of the current screen width, minimum 80, maximum 160
                    local w = math.floor(vim.o.columns * 0.6)
                    if w < 80 then w = 80 end
                    if w > 220 then w = 220 end
                    return w
                end,
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
