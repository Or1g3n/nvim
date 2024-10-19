local map = vim.api.nvim_set_keymap

-- Escape trigger
map('i', 'jj', '<Esc>', { noremap = true, silent = true })

-- File operations 
map('n', '<Leader>w', ':w<CR>', { noremap = true, silent = true })
map('n', '<Leader>q', ':q!<CR>', { noremap = true, silent = true })
map('n', '<Leader>x', ':x<CR>', { noremap = true, silent = true })

-- Buffer navigation
map('n', '<C-h>', '<C-W><C-h>', { noremap = true, silent = true }) -- Navigate left
map('n', '<C-l>', '<C-W><C-l>', { noremap = true, silent = true }) -- Navigate right
map('n', '<C-k>', '<C-W><C-k>', { noremap = true, silent = true }) -- Navigate up
map('n', '<C-j>', '<C-W><C-j>', { noremap = true, silent = true }) -- Navigate down
map('n', '<C-Left>', '<C-W><C-h>', { noremap = true, silent = true }) -- Navigate left
map('n', '<C-Right>', '<C-W><C-l>', { noremap = true, silent = true }) -- Navigate right
map('n', '<C-Up>', '<C-W><C-k>', { noremap = true, silent = true }) -- Navigate up
map('n', '<C-Down>', '<C-W><C-j>', { noremap = true, silent = true }) -- Navigate down

-- Auto find and replace
map('n', '<Leader>ra', 'yiw:%s/<C-r>"//gc<Left><Left><Left>', { noremap = true, silent = false }) -- Replace all words
map('v', '<Leader>ra', 'y:%s/<C-r>"//gc<Left><Left><Left>', { noremap = true, silent = false }) -- Replace all selected
map('n', '<Leader>rl', 'yiw:s/<C-r>"//gc<Left><Left><Left>', { noremap = true, silent = false }) -- Replace words on line
map('v', '<Leader>rl', 'y:s/<C-r>"//gc<Left><Left><Left>', { noremap = true, silent = false }) -- Replace selected on line

-- Code navigation
map('n', 'n', 'nzz', { noremap = true, silent = true }) -- Keep cursor center
map('n', 'N', 'Nzz', { noremap = true, silent = true }) -- Keep cursor center
map('n', '<C-u>', '<C-u>zz', { noremap = true, silent = true }) -- Keep cursor center
map('n', '<C-d>', '<C-d>zz', { noremap = true, silent = true }) -- Keep cursor center
