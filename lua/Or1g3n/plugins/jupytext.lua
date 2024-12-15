return {
    "GCBallesteros/jupytext.nvim",
    lazy=false,
    -- config = true
    config = function()
	local jupytext = require('jupytext')

	jupytext.setup({
	    style = "markdown",
	    output_extension = "md",
	    force_ft = "markdown",
	})
    end,
}
