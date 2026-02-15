-- Make sure to run :Copilot auth to authenticate with GitHub Copilot

return {
	'github/copilot.vim',
	enabled = true,
	config = function()
		vim.g.copilot_enabled = false

		-- Toggle Copilot suggestions
		vim.keymap.set('n', '<leader>cp', function()
			vim.g.copilot_enabled = not vim.g.copilot_enabled
			if vim.g.copilot_enabled then
				vim.notify("Copilot inline suggestions enabled", vim.log.levels.INFO)
			else
				vim.notify("Copilot inline suggestions disabled", vim.log.levels.INFO)
			end
		end, { desc = "Copilot: Toggle Copilot suggestions" })

		-- Accept word: <C-Right>
		vim.keymap.set('i', '<C-Right>', 'copilot#AcceptWord("<C-Right>")', { expr = true, replace_keycodes = false, desc = "Copilot: Accept word" })

		-- Accept line: <S-Right>
		vim.keymap.set('i', '<S-Right>', 'copilot#AcceptLine("<S-Right>")', { expr = true, replace_keycodes = false, desc = "Copilot: Accept line" })

	end,
}
