return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
	'saghen/blink.cmp',
	{
	    "folke/lazydev.nvim",
	    ft = "lua", -- only load on lua files
	    opts = {
		library = {
		    -- See the configuration section for more details
		    -- Load luvit types when the `vim.uv` word is found
		    { path = "${3rd}/luv/library", words = { "vim%.uv" } },
		},
	    },
	},
    },
    config = function()
	local capabilities = require('blink.cmp').get_lsp_capabilities()
	local lspconfig = require("lspconfig")
	local map = vim.keymap -- for conciseness

	-- Keymaps for LSP
	vim.api.nvim_create_autocmd("LspAttach", {
	    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	    callback = function(ev)
		local opts = { buffer = ev.buf, silent = true }

		-- Set LSP-related keybindings
		opts.desc = "LSP: Show references"
		map.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)

		opts.desc = "LSP: Go to declaration"
		map.set("n", "gD", vim.lsp.buf.declaration, opts)

		opts.desc = "LSP: Show definitions"
		map.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)

		opts.desc = "LSP: Show implementations"
		map.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

		opts.desc = "LSP: Show type definitions"
		map.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

		opts.desc = "LSP: See available code actions"
		map.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

		opts.desc = "LSP: Smart rename"
		map.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

		opts.desc = "LSP: Show buffer diagnostics"
		map.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

		-- opts.desc = "LSP: Show line diagnostics"
		-- map.set("n", "<leader>d", vim.diagnostic.open_float, opts)

		opts.desc = "LSP: Go to previous diagnostic"
		map.set("n", "[d", vim.diagnostic.goto_prev, opts)

		opts.desc = "LSP: Go to next diagnostic"
		map.set("n", "]d", vim.diagnostic.goto_next, opts)

		opts.desc = "LSP: Show documentation for what is under cursor"
		map.set("n", "K", vim.lsp.buf.hover, opts)

		opts.desc = "LSP: Restart"
		map.set("n", "<leader>rs", ":LspRestart<CR>", opts)
	    end,
	})

	-- LSP CONFIGS
	-- must explicitly call lspconfig.{server}.setup({}) for LSP to attach to Neovim buffer
	-- passing empty table to .setup({}) will use default configuration for lsp

	-- Configure the Lua language server
	lspconfig.lua_ls.setup({
	    capabilities = capabilities,
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
		},
	    },
	})

	-- Configure Pyright for Python
	lspconfig.pyright.setup({
	    cmd = { vim.fn.stdpath("data") .. "/mason/bin/pyright-langserver", "--stdio" },
	    capabilities = capabilities,
	    single_file_support = true,
	    root_dir = function(fname)
		-- Use the directory containing the .git folder or fallback to the file's directory
		local startpath = vim.fs.dirname(fname)
		local git_root = vim.fs.dirname(vim.fs.find('.git', { path = startpath, upward = true })[1])
		return git_root or startpath
	    end,
	    settings = {
		pyright = {
		    disableOrganizeImports = true, -- Using Ruff's import organizer
		},
		python = {
		    analysis = {
			-- Ignore all files for analysis to exclusively use Ruff for linting
			diagnosticMode = "openFilesOnly",
		    },
		},
	    },
	})

	-- Configure Marksman for Markdown
	lspconfig.marksman.setup({
	    filetypes = { "markdown", "md" },
	    capabilities = capabilities,
	    root_dir = function(fname)
		-- Use the directory containing the .git folder or fallback to the file's directory
		local startpath = vim.fs.dirname(fname)
		local git_root = vim.fs.dirname(vim.fs.find('.git', { path = startpath, upward = true })[1])
		return git_root or startpath
	    end,
	})

    end,
}

