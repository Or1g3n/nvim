-- A snacks.nvim–based picker for switching to Python projects and activating their venvs
local customutils = require("Or1g3n.core.custom.utils")
local projects = customutils.safe_require("Or1g3n.plugins.local.project_picker.projects", nil)

local M = {}

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

-- Main picker function
function M.project_picker()

    -- If projects file doesn't exist
    if projects == nil then
	vim.notify(
[[
*projects.lua file not found.*

Create at nvim/lua/Or1g3n/plugins/local/project_picker/projects.lua

Example:
```lua
--  projects.lua
return {
    { 
	name = 'myproject',
	dir = 'C:/Users/MyUser/MyProject',
    },
}
```
]],
	    vim.log.levels.WARN,
	{ title = "Projects", timeout = 5000 }
	)
	return
    end

    Snacks.picker.pick({
	source  = "Projects",
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

	    vim.notify("Working directory activated: " .. p.name, vim.log.levels.INFO, { title = "Projects" })
	end,
    })
end

return M
