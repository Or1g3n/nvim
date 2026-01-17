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

    -- Check required opts
    if opts.title == nil then
	vim.notify(
	    'Missing required option: `title`',
	    vim.log.levels.ERROR,
	    { title = 'Create Floating Window', timeout = 5000 }
	)
	return
    end

    local scaling_factor = opts.scaling_factor or .8
    local width = opts.width or math.floor(vim.o.columns * scaling_factor)
    local height = opts.height or math.floor(vim.o.lines * scaling_factor)

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

    -- Define base window configuration and merge in user options
    local base_win_config = {
	relative = 'editor',
	width = width,
	height = height,
	col = col,
	row = row,
	style = 'minimal',
	border = 'rounded',
	title = ' ' .. opts.title .. ' ',
	title_pos = 'center'
    }

    local win_config = vim.tbl_deep_extend("force", base_win_config, opts.win_config or {})

    -- Create the floating window
    local win = vim.api.nvim_open_win(buf, true, win_config)

    return { buf = buf, win = win }
end

local toggle_terminal = function()
    if not vim.api.nvim_win_is_valid(state.floating.win) then
	result = create_floating_window({ title = 'Terminal', buf = state.floating.buf })
	if not result then
	    return -- Exit if create_floating_window failed
	end
	state.floating = result
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
