return {
    'tpope/vim-obsession',
    config = function()
	local home_dir = os.getenv("HOME") or os.getenv("USERPROFILE")  -- Cross-platform home directory
        local session_dir = home_dir .. "/.nvim-sessions"  -- Directory for session files
        _G.session_file = session_dir .. "/session.vim"  -- Path to session file

        -- Create the directory if it doesn't exist
        if vim.fn.isdirectory(session_dir) == 0 then
            vim.fn.mkdir(session_dir, "p")  -- Create the directory and any necessary parent directories
        end

        -- Create the session file if it doesn't exist
        if vim.fn.filereadable(session_file) == 0 then
            vim.fn.writefile({}, session_file)
        end

	-- Set keymaps
	local map = vim.keymap

	map.set('n', '<leader>os', ':Obsess ' .. session_file .. '<CR>', { noremap = true, silent = true, desc = "Start saving nvim session" })
	map.set('n', '<leader>od', ':Obsess!<CR>', { noremap = true, silent = true, desc = "Stop nvim session and delete it" })
	map.set('n', '<leader>or', ':source ' .. session_file .. '<CR>', { noremap = true, silent = true, desc = "Restore last saved session" })

    end
}
