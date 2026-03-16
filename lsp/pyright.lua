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
				-- reportUnusedImport = false,
				-- reportUnusedVariable = false,
				-- reportMissingImports = false,
			},
		},
	},
	-- on_init = function(client)
		-- ---@type lsp.ServerCapabilities
		-- local capabilities = assert(client.server_capabilities)
		-- ty features
		-- capabilities.semanticTokensProvider = nil
		-- capabilities.documentHighlightProvider = nil
		-- capabilities.documentSymbolProvider = nil
		-- capabilities.foldingRangeProvider = nil
		-- capabilities.workspaceSymbolProvider = nil
		-- capabilities.callHierarchyProvider = nil
		-- capabilities.completionProvider = nil
		-- capabilities.declarationProvider = nil
		-- capabilities.definitionProvider = nil
		-- capabilities.implementationProvider = nil
		-- capabilities.inlayHintProvider = nil
		-- capabilities.notebookDocumentSync = nil
		-- capabilities.referencesProvider = nil
		-- capabilities.renameProvider = nil
		-- capabilities.signatureHelpProvider = nil
		-- capabilities.typeDefinitionProvider = nil
		-- capabilities.hoverProvider = nil
		-- capabilities.workspace = nil
	-- end,
}
