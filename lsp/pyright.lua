return {
	cmd = { vim.fn.stdpath("data") .. "/mason/bin/pyright-langserver", "--stdio" },
	single_file_support = true,
	settings = {
		pyright = {
			disableOrganizeImports = true, -- Using Ruff's import organizer
		},
		python = {
			analysis = {
				diagnosticMode = "openFilesOnly",
				autoImportCompletions = false,
			},
		},
	},
}
