-- NOTE: git handling may not be required after adding more nushell specific settings
-- Ensure that forward slash is turned off when using git
-- vim.api.nvim_create_autocmd("BufReadPre", {
--     pattern = "COMMIT_EDITMSG",
--     callback = function()
--
-- 	-- Debugging: print a message when the autocommand runs
-- 	vim.notify("Git commit message file opened. Temporarily disabling shellslash.", vim.log.levels.INFO)
-- 	-- Temporarily disable shellslash for Git commit messages
-- 	vim.o.shellslash = false
--     end
-- })

-- Ensure shellslash is set for Jupytext files
vim.api.nvim_create_autocmd({"BufReadCmd"}, {
    pattern = {"*.ipynb"},
    callback = function()
	vim.opt_local.shellslash = true
    end,
    desc = "Ensure shellslash is set for Jupytext files",
})

-- HELP BUFFERS
-- Open help buffers as vert splits as opposed to default horizontal
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "help", "man", "markdown"},
    callback = function()
	if vim.bo.buftype ~= "nofile" then
	    vim.cmd("wincmd L")
	end
    end,
    desc = "Open help buffers as vert splits as opposed to default horizontal"
})
-- Turn off diagnostics for help files
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "help", "man", "markdown" },
    callback = function()
	if vim.bo.buftype == "help" then
	    vim.diagnostic.enable(false, {bufnr=0}) -- Disable diagnostics for the current buffer
	end
    end,
    desc = "Disable LSP diagnostics in help files",
})

-- Highlight visual cue when copying text
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Editor: Highlight when copying text',
    group = vim.api.nvim_create_augroup('or1g3n-highlight-yank', { clear = true }),
    callback = function()
	vim.hl.on_yank()
    end,
})
