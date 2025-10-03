-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
	vim.api.nvim_echo({
	    { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
	    { out, "WarningMsg" },
	    { "\nPress any key to exit..." },
	}, true, {})
	vim.fn.getchar()
	os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
    spec = {
	-- import your plugins
	{ import = "Or1g3n.plugins" },
	{ import = "Or1g3n.plugins.ai" },
	{ import = "Or1g3n.plugins.debug" },
	{ import = "Or1g3n.plugins.lsp" },
	{ import = "Or1g3n.plugins.snacks" },
    },
    rocks = {
	enabled = true,
	root = vim.fn.stdpath("data") .. "/lazy-rocks",
	server = "https://nvim-neorocks.github.io/rocks-binaries/",
	-- use hererocks to install luarocks?
	-- set to `nil` to use hererocks when luarocks is not found
	-- set to `true` to always use hererocks
	-- set to `false` to always use luarocks
	hererocks = nil,
    },
    checker = {
	-- automatically check for plugin updates
	enabled = false,
	concurrency = nil, ---@type number? set to 1 to check for updates very slowly
	notify = true, -- get a notification when new updates are found
	frequency = 3600, -- check for updates every hour
	check_pinned = false, -- check for pinned packages that can't be updated
    },
    change_detection = {
	-- automatically check for config file changes and reload the ui
	enabled = true,
	notify = false, -- get a notification when changes are found
    },
    ui = {
	border = "rounded",
    }
})
