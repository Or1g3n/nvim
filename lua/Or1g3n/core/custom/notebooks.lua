-- Provide a command to create a blank new Python notebook
-- note: the metadata is needed for Jupytext to understand how to parse the notebook.
-- if you use another language than Python, you should change it in the template.
local default_notebook = [[
{
    "cells": [
	{
	    "cell_type": "code",
	    "execution_count": null,
	    "metadata": {},
	    "outputs": [],
	    "source": [
		""
	    ]
	},
	{
	    "cell_type": "markdown",
	    "metadata": {},
	    "source": [
		""
	    ]
	}
    ],
    "metadata": {
	"kernelspec": {
	    "display_name": "Python 3",
	    "language": "python",
	    "name": "python3"
	},
	"language_info": {
	    "codemirror_mode": {
		"name": "ipython",
		"version": 3
	    },
	    "file_extension": ".py",
	    "mimetype": "text/x-python",
	    "name": "python",
	    "nbconvert_exporter": "python",
	    "pygments_lexer": "ipython3"
	}
    },
    "nbformat": 4,
    "nbformat_minor": 2
}
]]

local function new_notebook(filename)
    local path = filename .. ".ipynb"
    local file = io.open(path, "w")
    if file then
	file:write(default_notebook)
	file:close()
	vim.cmd("edit " .. path)
    else
	print("Error: Could not open new notebook file for writing.")
    end
end

vim.api.nvim_create_user_command(
    'NewNotebook',
    function(opts)
	new_notebook(opts.args)
    end,
    {
	nargs = 1,
	complete = 'file'
    }
)
