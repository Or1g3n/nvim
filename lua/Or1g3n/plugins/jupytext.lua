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

	vim.api.nvim_create_user_command("JupytextToggleMarkdown",
	    function()
		vim.g.render_ipynb_as_markdown = not vim.g.render_ipynb_as_markdown
		vim.cmd("Lazy reload jupytext.nvim")
		vim.notify("Render as markdown: " .. tostring(vim.g.render_ipynb_as_markdown))
	    end,
	    {}
	)

	vim.api.nvim_create_user_command("JupytextExportAsPy",
	    function()
		local filename = vim.fn.expand("%:t")
		local fullpath = vim.fn.expand("%:p")
		local stderr_output = {}

		vim.fn.jobstart({ "jupytext", "--to", "py:percent", fullpath }, {
		    stdout_buffered = true,
		    stderr_buffered = true,
		    on_stderr = function(_, data, _)
			for _, line in ipairs(data) do
			    if line ~= "" then
				table.insert(stderr_output, line)
			    end
			end
		    end,
		    on_exit = function(_, exit_code, _)
			if exit_code == 0 then
			    vim.notify("✅ Exported '" .. filename .. "' to Python format", vim.log.levels.INFO)
			else
			    local msg = "❌ Failed to export '" .. filename .. "' to Python.\n" .. table.concat(stderr_output, "\n")
			    vim.notify(msg, vim.log.levels.ERROR)
			end
		    end,
		})
	    end,
	    {}
	)

    end,
}
