-- Terminal config on open
vim.api.nvim_create_autocmd('TermOpen', {
    desc = 'Terminal: Set options upon terminal open',
    group = vim.api.nvim_create_augroup('or1g3n-terminal-open', { clear = true }),
    callback = function()
	vim.opt.number = false
	vim.opt.relativenumber = false
    end,
})

-- Floating terminal
local state = {
    floating = {
	buf = -1,
	win = -1
    }
}

local utils = require('Or1g3n.core.custom.utils')

local terminal_win_config = { title = ' Terminal ', title_pos = 'center' }

local toggle_terminal = function()
    if not vim.api.nvim_win_is_valid(state.floating.win) then
	state.floating = utils.create_floating_window({ win_config = terminal_win_config, buf = state.floating.buf })
	if vim.bo[state.floating.buf].buftype ~= 'terminal' then
	    vim.cmd.terminal()
	    vim.cmd.startinsert() -- Start in insert mode
	end
    else
	vim.api.nvim_win_hide(state.floating.win)
    end
end

-- USER COMMAND AND KEYMAPS
local map = vim.keymap

-- Toggle Terminal
vim.api.nvim_create_user_command('ToggleTerminal', toggle_terminal, {})
map.set('n', '<Leader>t', toggle_terminal, { desc = 'Terminal: Toggle floating terminal' })

-- General
map.set('t', '<Esc><Esc>', '<c-\\><c-n>', { noremap = true, desc = "Terminal: activate normal mode" })
