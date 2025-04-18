return {
    "GCBallesteros/jupytext.nvim",
    lazy=false,
    -- config = true
    config = function()
	local jupytext = require('jupytext')

	-- Check the global toggle variable (default to true if not set)
	local render_as_md = vim.g.render_ipynb_as_markdown
	if render_as_md == nil then
	    render_as_md = true
	end

	-- Set config
	local jupy_config = {}
	if render_as_md then
	    jupy_config = {
		style = "markdown",
		output_extension = "md",
		force_ft = "markdown",
	    }
	end
	jupytext.setup( jupy_config )

	vim.api.nvim_create_user_command("ToggleJupytextMarkdown",
	    function()
		vim.g.render_ipynb_as_markdown = not vim.g.render_ipynb_as_markdown
		vim.cmd("Lazy reload jupytext.nvim")
		vim.notify("Render as markdown: " .. tostring(vim.g.render_ipynb_as_markdown))
	    end,
	    {}
	)
    end,
}
