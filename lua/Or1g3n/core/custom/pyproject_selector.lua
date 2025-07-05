-- A snacks.nvim–based picker for switching to Python projects and activating their venvs
local customutils = require("Or1g3n.core.custom.utils")
local projects = customutils.safe_require("Or1g3n.plugins.local.pyproject_selector.pyprojects", nil)

local M = {}

-- Normalize Windows paths to use forward slashes
local function normalize(path)
    return path:gsub("\\", "/")
end

-- Build picker items
local function make_items()
    local items = {}
    for _, p in ipairs(projects) do
	table.insert(items, {
	    text    = p.name,
	    project = p,
	})
    end
    return items
end

-- Update LSP
local function reload_lsps(new_python)
    for _, client in ipairs(vim.lsp.get_clients()) do
	if client.name:match("pyright") or client.name:match("pylsp") then
	    -- Update pythonPath setting and notify the LSP
	    local new_settings = vim.tbl_deep_extend(
		"force",
		client.config.settings or {},
		{ python = { pythonPath = new_python } }
	    )
	    client.config.settings = new_settings
	    client.notify("workspace/didChangeConfiguration", { settings = new_settings })
	end
    end
end

-- Main picker function
function M.python_project_picker()

    -- If projects file doesn't exist
    if projects == nil then
	vim.notify(
[[
*pyprojects.lua file not found.*

Create at nvim/lua/Or1g3n/plugins/local/pyproject_selector/pyprojects.lua

Example:
```lua
-- pyprojects.lua
return {
    { 
	name = 'myproject',
	dir = 'C:/Users/MyUser/MyProject/python',
	venv = 'C:/Users/MyUser/MyProject/python/.venv'
    },
}
```
]],
	    vim.log.levels.WARN,
	{ title = "Python Projects", timeout = 5000 }
	)
	return
    end

    Snacks.picker.pick({
	source  = "Python Projects",
	items   = make_items(),
	preview = "none",
	layout  = { preset = "select" },
	format  = "text",
	confirm = function(picker, item)
	    -- Close the picker immediately upon selection
	    picker:close()

	    local p = item.project

	    -- 1) change Neovim cwd
	    vim.api.nvim_set_current_dir(p.dir)

	    -- 2) mutate Neovim process env for venv
	    local sep = package.config:sub(1,1)
	    local scripts_dir = p.venv .. sep .. (vim.fn.has("win32") == 1 and "Scripts" or "bin")
	    local norm_scripts_dir = normalize(scripts_dir)
	    vim.env.PATH = norm_scripts_dir .. sep .. vim.env.PATH
	    vim.env.VIRTUAL_ENV = normalize(p.venv)

	    -- 3) point Python provider at venv's python (will work for new children, but internal provider requires restart)
	    local python_exec = norm_scripts_dir .. sep .. (vim.fn.has("win32") == 1 and "python.exe" or "python")
	    vim.g.python3_host_prog = normalize(python_exec)

	    -- 4) reload LSPs so they pick up new interpreter
	    reload_lsps(python_exec)

	    vim.notify("Activated venv: " .. p.name, vim.log.levels.INFO, { title = "Python Projects" })
	end,
    })
end

return M
