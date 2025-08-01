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
	'folke/snacks.nvim',
    },
    config = function()
	local capabilities = require('blink.cmp').get_lsp_capabilities()
	local lspconfig = require("lspconfig")
	local snacks = require('snacks')
	local map = vim.keymap -- for conciseness

	-- Diagnostics
	-- Set global defaults
	vim.diagnostic.config({
	    virtual_text = true,
	    virtual_lines = false
	})
	-- Toggle diagnostics
	map.set("n", "<leader>vt",
	    function()
		local new_config = not vim.diagnostic.config().virtual_text
		vim.diagnostic.config({ virtual_text = new_config })
	    end,
	    { desc = "Toggle diagnostic virtual text" }
	)
	map.set("n", "<leader>vl",
	    function()
		local new_config = not vim.diagnostic.config().virtual_lines
		vim.diagnostic.config({ virtual_lines = new_config })
	    end,
	    { desc = "Toggle diagnostic virtual lines" }
	)

	-- Keymaps for LSP
	vim.api.nvim_create_autocmd("LspAttach", {
	    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	    callback = function(ev)
		local opts = { buffer = ev.buf, silent = true }

		-- Set LSP-related keybindings
		-- snacks.picker based lsp keymaps
		opts.desc = "LSP: Goto Definition"
		map.set('n', "gd", function() snacks.picker.lsp_definitions() end, opts)

		opts.desc = "LSP: Search References"
		opts.nowait = true
		map.set('n', "gr", function() snacks.picker.lsp_references() end, opts)

		opts.desc = "LSP: Goto Implementation"
		map.set('n', "gI", function() snacks.picker.lsp_implementations() end, opts)

		opts.desc = "LSP: Goto T[y]pe Definition"
		map.set('n', "gy", function() snacks.picker.lsp_type_definitions() end, opts)

		opts.desc = "LSP: Search LSP Symbols"
		map.set('n', "<leader>ss", function() snacks.picker.lsp_symbols() end, opts)

		-- vim built-in based lsp keymaps
		opts.desc = "LSP: Show documentation for what is under cursor"
		map.set("n", "K", function() vim.lsp.buf.hover({ border = 'single' }) end, opts)

		opts.desc = "LSP: Go to declaration"
		map.set("n", "gD", vim.lsp.buf.declaration, opts)

		opts.desc = "LSP: See available code actions"
		map.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

		opts.desc = "LSP: Go to next diagnostic"
		map.set("n", "]d", vim.diagnostic.goto_next, opts)

		opts.desc = "LSP: Format document"
		map.set("n", "<leader>-", vim.lsp.buf.format, opts)
		-- TODO: figure out how to get conform to work

		opts.desc = "LSP: Go to previous diagnostic"
		map.set("n", "[d", vim.diagnostic.goto_prev, opts)

		opts.desc = "LSP: Smart rename"
		map.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

		opts.desc = "LSP: Restart"
		map.set("n", "<leader>rs", ":LspRestart<CR>", opts)

		opts.desc = "LSP: Toggle inlay hints"
		map.set("n", "<leader>ih",
		    function()
			local clients = vim.lsp.get_clients({ bufnr = 0 })
			for _, client in ipairs(clients) do
			    if client.supports_method("textDocument/inlayHint") then
				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
				return
			    end
			end
			vim.notify("Inlay hints not supported by any attached LSP", vim.log.levels.WARN)
		    end,
		    opts
		)

	    end,
	})

	-- LSP Load Progress
	vim.api.nvim_create_autocmd("LspProgress", {
	    ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
	    callback = function(ev)
		local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
		vim.notify(vim.lsp.status(), "info", {
		    id = "lsp_progress",
		    title = "LSP Progress",
		    opts = function(notif)
			notif.icon = ev.data.params.value.kind == "end" and " "
			or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
		    end,
		})
	    end,
	})

	-- LSP CONFIGS
	-- must explicitly call lspconfig.{server}.setup({}) for LSP to attach to Neovim buffer
	-- passing empty table to .setup({}) will use default configuration for lsp

	-- Configure lsp-json for json
	lspconfig.jsonls.setup({
	    cmd = { "vscode-json-language-server", "--stdio" },
	    filetypes = { "json", "jsonc" },
	    init_options = {
		provideFormatter = true
	    },
	    single_file_support = true
	})

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
		    hint =  { enable = true },
		    type = { enable = true }
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
			autoImportCompletions = false,
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

	-- Configure ZLS for Zig
	require('lspconfig').zls.setup{}

    end,
}

