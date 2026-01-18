local M = {}

-- Safely reference modules that may or may not exist
function M.safe_require(module, fallback)
    local ok, result = pcall(require, module)
    return ok and result or fallback
end

-- Create floating windows
--- @param opts table Options for window creation:
---   opts.height         (number)  Window height in lines (optional)
---   opts.width          (number)  Window width in columns (optional)
---   opts.scaling_factor (number)  Fraction of editor size for window (optional, default: 0.8)
---   opts.buf            (number)  Buffer to display in window (optional)
---   opts.win_config     (table)   Additional window config options. See `:h api-win_config` (optional)
--- @return table { buf = buffer_handle, win = window_handle }
function M.create_floating_window(opts)
    opts = opts or {}

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
    }

    local win_config = vim.tbl_deep_extend("force", base_win_config, opts.win_config or {})

    -- Create the floating window
    local win = vim.api.nvim_open_win(buf, true, win_config)

    return { buf = buf, win = win }
end

return M
