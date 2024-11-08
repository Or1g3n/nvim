local map = vim.keymap -- for conciseness

-- Escape trigger
map.set('i', 'jj', '<Esc>', { noremap = true, silent = true, desc = "Editor: Exit insert mode" })

-- Jumping
map.set('n', '<A-o>', '<C-]>', { noremap = true, silent = true, desc = "Editor: Jump to definition" })

-- File operations 
map.set('n', '<Leader>w', ':w<CR>', { noremap = true, silent = true, desc = "Editor: Save file" })
map.set('n', '<Leader>q', ':q!<CR>', { noremap = true, silent = true, desc = "Editor: Quit without saving" })
map.set('n', '<Leader>x', ':x<CR>', { noremap = true, silent = true, desc = "Editor: Save and quit" })

-- Buffer navigation
map.set('n', '<C-h>', '<C-W><C-h>', { noremap = true, silent = true, desc = "Buffer: Navigate left" })
map.set('n', '<C-l>', '<C-W><C-l>', { noremap = true, silent = true, desc = "Buffer: Navigate right" })
map.set('n', '<C-k>', '<C-W><C-k>', { noremap = true, silent = true, desc = "Buffer: Navigate up" })
map.set('n', '<C-j>', '<C-W><C-j>', { noremap = true, silent = true, desc = "Buffer: Navigate down" })
map.set('n', '<C-Left>', '<C-W><C-h>', { noremap = true, silent = true, desc = "Buffer: Navigate left" })
map.set('n', '<C-Right>', '<C-W><C-l>', { noremap = true, silent = true, desc = "Buffer: Navigate right" })
map.set('n', '<C-Up>', '<C-W><C-k>', { noremap = true, silent = true, desc = "Buffer: Navigate up" })
map.set('n', '<C-Down>', '<C-W><C-j>', { noremap = true, silent = true, desc = "Buffer: Navigate down" })
-- Buffer layout 
map.set('n', '<Leader>h', ':wincmd H<CR>', { noremap = true, silent = true, desc = "Buffer: Move left" })
map.set('n', '<Leader>l', ':wincmd L<CR>', { noremap = true, silent = true, desc = "Buffer: Move right" })
map.set('n', '<Leader>k', ':wincmd K<CR>', { noremap = true, silent = true, desc = "Buffer: Move up" })
map.set('n', '<Leader>j', ':wincmd J<CR>', { noremap = true, silent = true, desc = "Buffer: Move down" })
map.set('n', '<A-=>', ':wincmd =<CR>', { noremap = true, silent = true, desc = "Buffer: Rebalance layout" })
map.set('n', '<A-j>', ':resize +2<CR>', { noremap = true, silent = true, desc = "Buffer: Increase height" })
map.set('n', '<A-k>', ':resize -2<CR>', { noremap = true, silent = true, desc = "Buffer: Decrease height" })
-- Resize width (left or right based on active window position)
map.set('n', '<A-l>', function()
    local max_windows  = #vim.api.nvim_list_wins()
    local col = vim.fn.winnr() -- Get current window number in current row
    if col == max_windows then
	vim.cmd 'vertical resize -2' -- Decrease width if on the right
    else
	vim.cmd 'vertical resize +2' -- Increase width if on the left
    end
end, { noremap = true, silent = true, desc = "Buffer: Adjust width based on position" })

map.set('n', '<A-h>', function()
    local max_windows  = #vim.api.nvim_list_wins()
    local col = vim.fn.winnr() -- Get current window number in current row
    if col == max_windows then
	vim.cmd 'vertical resize +2' -- Increase width if on the right
    else
	vim.cmd 'vertical resize -2' -- Decrease width if on the left
    end
end, { noremap = true, silent = true, desc = "Buffer: Adjust width based on position" })


-- Auto find and replace
map.set('n', '<Leader>ra', 'yiw:%s/<C-r>"//gc<Left><Left><Left>', { noremap = true, silent = false, desc = "Editor: Replace all occurrences of word" })
map.set('v', '<Leader>ra', 'y:%s/<C-r>"//gc<Left><Left><Left>', { noremap = true, silent = false, desc = "Editor: Replace all occurrences of selection" })
map.set('n', '<Leader>rl', 'yiw:s/<C-r>"//gc<Left><Left><Left>', { noremap = true, silent = false, desc = "Editor: Replace occurrences of word on line" })
map.set('v', '<Leader>rl', 'y:s/<C-r>"//gc<Left><Left><Left>', { noremap = true, silent = false, desc = "Editor: Replace occurrences of selection on line" })

-- Code navigation
map.set('n', 'n', 'nzz', { noremap = true, silent = true, desc = "Editor: Next search result centered" })
map.set('n', 'N', 'Nzz', { noremap = true, silent = true, desc = "Editor: Previous search result centered" })
map.set('n', '<C-u>', '2kzz', { noremap = true, silent = true, desc = "Editor: Scroll up centered" })
map.set('n', '<C-d>', '2jzz', { noremap = true, silent = true, desc = "Editor: Scroll down centered" })

-- Copy / Paste
map.set('n', '<Leader>y', '"+y', { noremap = true, silent = true, desc = "Editor: Copy motion into clipboard" })
map.set('n', '<Leader>Y', '"+Y', { noremap = true, silent = true, desc = "Editor: Copy line into clipboard" })
map.set('v', '<Leader>y', '"+y', { noremap = true, silent = true, desc = "Editor: Copy selection into clipboard" })
map.set('x', '<Leader>p', '"_dP', { noremap = true, silent = true, desc = "Editor: Paste without overwriting clipboard" })
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Editor: Highlight when copying text',
  group = vim.api.nvim_create_augroup('or1g3n-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Delete
map.set('n', '<Leader>d', '"_d', { noremap = true, silent = true, desc = "Editor: Delete motion but keep yank buffer" })
map.set('v', '<Leader>d', '"_d', { noremap = true, silent = true, desc = "Editor: Delete selection keep yank buffer" })

-- Line manipulation 
map.set('v', 'K', ":m '<-2<CR>gv=gv", { noremap = true, silent = true, desc = "Editor: Move lines up" })
map.set('v', 'J', ":m '>+1<CR>gv=gv", { noremap = true, silent = true, desc = "Editor: Move lines down" })
map.set('n', 'J', 'mzJ`z', { noremap = true, silent = true, desc = "Editor: Join lines while maintaining cursor position" })
map.set('n', '<Tab>', '>>_', { noremap = true, silent = true, desc = "Editor: Indent in normal mode using tab" })
map.set('n', '<S-Tab>', '<<_', { noremap = true, silent = true, desc = "Editor: Dedent in normal mode using tab" })
map.set('v', '<Tab>', '>gv', { noremap = true, silent = true, desc = "Editor: Indent in normal mode using tab" })
map.set('v', '<S-Tab>', '<gv', { noremap = true, silent = true, desc = "Editor: Dedent in normal mode using tab" })
