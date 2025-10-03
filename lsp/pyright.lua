return {
    cmd = { vim.fn.stdpath("data") .. "/mason/bin/pyright-langserver", "--stdio" },
    single_file_support = true,
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
}
