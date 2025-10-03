return {
    settings = {
	Lua = {
	    runtime = {
		version = 'LuaJIT', -- Use LuaJIT for Neovim
		path = vim.split(package.path, ';'),
	    },
	    diagnostics = { globals = { "vim" } }, -- Recognize 'vim' as a global
	    workspace = {
		library = vim.api.nvim_get_runtime_file('', true),
		checkThirdParty = false, -- Disable third-party library checks
	    },
	    completion = { callSnippet = "Replace" },
	    hint =  { enable = true },
	    type = { enable = true }
	},
    },
}
