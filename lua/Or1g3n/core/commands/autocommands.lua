-- Ensure that forward slash is turned off when using git
vim.api.nvim_create_autocmd("BufReadPre", {
    pattern = "COMMIT_EDITMSG",
    callback = function()
	-- Save the original shellslash setting
	local original_shellslash = vim.o.shellslash

	-- Debugging: print a message when the autocommand runs
	vim.notify("Git commit message file opened. Temporarily disabling shellslash.", vim.log.levels.INFO)
	-- Temporarily disable shellslash for Git commit messages
	vim.o.shellslash = false

	-- -- Revert shellslash right before Neovim exits
	-- vim.api.nvim_create_autocmd("VimLeavePre", {
	--     buffer = 0,
	--     callback = function()
	-- 	vim.o.shellslash = original_shellslash
	--     end
	-- })
    end
})
