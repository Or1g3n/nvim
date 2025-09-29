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

local function create_floating_window(opts)
    opts = opts or {}
    local width = opts.width or math.floor(vim.o.columns * 0.8)
    local height = opts.height or math.floor(vim.o.lines * 0.8)

    -- Calculate the position to center the window
    local col = math.floor((vim.o.columns - width) / 2)
    local row = math.floor((vim.o.lines - height) / 2)

    -- Create a buffer
    local buf = nil
    if vim.api.nvim_buf_is_valid(opts.buf) then
	buf = opts.buf
    else
	buf = vim.api.nvim_create_buf(false, true) -- No file
    end

    -- Define window configuration
    local win_config = {
	relative = 'editor',
	width = width,
	height = height,
	col = col,
	row = row,
	style = 'minimal', -- No borders or extra UI elements
	border = 'rounded',
	title = 'Terminal',
	title_pos = 'center'
    }

    -- Create the floating window
    local win = vim.api.nvim_open_win(buf, true, win_config)

    return { buf = buf, win = win }
end

local toggle_terminal = function()
    if not vim.api.nvim_win_is_valid(state.floating.win) then
	state.floating = create_floating_window({ buf = state.floating.buf })
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
