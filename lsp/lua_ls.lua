return {
    settings = {
	Lua = {
	    runtime = {
		version = 'LuaJIT', -- Use LuaJIT for Neovim
		path = vim.split(package.path, ';'),
	    },
	    diagnostics = { globals = { "vim" } }, -- Recognize 'vim' as a global
	    workspace = {
		-- Workspace management is handled via lazydev, see nvim/lua/Or1g3n/plugins/lsp/lspconfig.lua 
		-- library = vim.api.nvim_get_runtime_file('', true),
		checkThirdParty = false, -- Disable third-party library checks
	    },
	    completion = {
		callSnippet = "Replace"
	    },
	    doc = {
		privateName = { "^_" },
	    },
	    hint =  { enable = true },
	    type = { enable = true }
	},
    },
}
