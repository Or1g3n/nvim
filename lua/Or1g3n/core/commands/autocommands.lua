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
