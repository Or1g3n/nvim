local map = vim.keymap -- for conciseness

-- Escape trigger
map.set('i', 'jj', '<Esc>', { noremap = true, silent = true, desc = "Exit insert mode" })

-- Jumping
map.set('n', '<A-o>', '<C-]>', { noremap = true, silent = true, desc = "Jump to definition" })

-- File operations 
map.set('n', '<Leader>w', ':w<CR>', { noremap = true, silent = true, desc = "Save file" })
map.set('n', '<Leader>q', ':q!<CR>', { noremap = true, silent = true, desc = "Quit without saving" })
map.set('n', '<Leader>x', ':x<CR>', { noremap = true, silent = true, desc = "Save and quit" })

-- Buffer navigation
map.set('n', '<C-h>', '<C-W><C-h>', { noremap = true, silent = true, desc = "Navigate left" })
map.set('n', '<C-l>', '<C-W><C-l>', { noremap = true, silent = true, desc = "Navigate right" })
map.set('n', '<C-k>', '<C-W><C-k>', { noremap = true, silent = true, desc = "Navigate up" })
map.set('n', '<C-j>', '<C-W><C-j>', { noremap = true, silent = true, desc = "Navigate down" })
map.set('n', '<C-Left>', '<C-W><C-h>', { noremap = true, silent = true, desc = "Navigate left" })
map.set('n', '<C-Right>', '<C-W><C-l>', { noremap = true, silent = true, desc = "Navigate right" })
map.set('n', '<C-Up>', '<C-W><C-k>', { noremap = true, silent = true, desc = "Navigate up" })
map.set('n', '<C-Down>', '<C-W><C-j>', { noremap = true, silent = true, desc = "Navigate down" })
-- Buffer layout 
map.set('n', '<Leader>h', ':wincmd H<CR>', { noremap = true, silent = true, desc = "Move buffer left" })
map.set('n', '<Leader>l', ':wincmd L<CR>', { noremap = true, silent = true, desc = "Move buffer right" })
map.set('n', '<Leader>k', ':wincmd K<CR>', { noremap = true, silent = true, desc = "Move buffer up" })
map.set('n', '<Leader>j', ':wincmd J<CR>', { noremap = true, silent = true, desc = "Move buffer down" })
map.set('n', '<A-j>', ':resize +2<CR>', { noremap = true, silent = true, desc = "Increase buffer height" })
map.set('n', '<A-k>', ':resize -2<CR>', { noremap = true, silent = true, desc = "Decrease buffer height" })
-- Resize width (left or right based on active window position)
map.set('n', '<A-l>', function()
    local col = vim.fn.winnr() -- Get current window number in current row
    if col == 1 then
        vim.cmd 'vertical resize +2' -- Increase width if on the left
    else
        vim.cmd 'vertical resize -2' -- Decrease width if on the right
    end
end, { noremap = true, silent = true, desc = "Adjust width based on position" })

map.set('n', '<A-h>', function()
    local col = vim.fn.winnr() -- Get current window number in current row
    if col == 1 then
        vim.cmd 'vertical resize -2' -- Decrease width if on the left
    else
        vim.cmd 'vertical resize +2' -- Increase width if on the right
    end
end, { noremap = true, silent = true, desc = "Adjust width based on position" })


-- Auto find and replace
map.set('n', '<Leader>ra', 'yiw:%s/<C-r>"//gc<Left><Left><Left>', { noremap = true, silent = false, desc = "Replace all occurrences of word" })
map.set('v', '<Leader>ra', 'y:%s/<C-r>"//gc<Left><Left><Left>', { noremap = true, silent = false, desc = "Replace all occurrences of selection" })
map.set('n', '<Leader>rl', 'yiw:s/<C-r>"//gc<Left><Left><Left>', { noremap = true, silent = false, desc = "Replace occurrences of word on line" })
map.set('v', '<Leader>rl', 'y:s/<C-r>"//gc<Left><Left><Left>', { noremap = true, silent = false, desc = "Replace occurrences of selection on line" })

-- Code navigation
map.set('n', 'n', 'nzz', { noremap = true, silent = true, desc = "Next search result centered" })
map.set('n', 'N', 'Nzz', { noremap = true, silent = true, desc = "Previous search result centered" })
map.set('n', '<C-u>', '<C-u>zz', { noremap = true, silent = true, desc = "Scroll up centered" })
map.set('n', '<C-d>', '<C-d>zz', { noremap = true, silent = true, desc = "Scroll down centered" })

-- Copy / Paste
map.set('n', '<Leader>y', '"+y', { noremap = true, silent = true, desc = "Copy motion into clipboard" })
map.set('n', '<Leader>Y', '"+Y', { noremap = true, silent = true, desc = "Copy line into clipboard" })
map.set('v', '<Leader>y', '"+y', { noremap = true, silent = true, desc = "Copy selection into clipboard" })
map.set('x', '<Leader>p', '"_dP', { noremap = true, silent = true, desc = "Paste without overwriting clipboard" })

-- Delete
map.set('n', '<Leader>d', '"_d', { noremap = true, silent = true, desc = "Delete motion but keep yank buffer" })
map.set('v', '<Leader>d', '"_d', { noremap = true, silent = true, desc = "Delete selection keep yank buffer" })

-- Line manipulation 
map.set('v', 'K', ":m '<-2<CR>gv=gv", { noremap = true, silent = true, desc = "Move lines up" })
map.set('v', 'J', ":m '>+1<CR>gv=gv", { noremap = true, silent = true, desc = "Move lines down" })
map.set('n', 'J', 'mzJ`z', { noremap = true, silent = true, desc = "Join lines while maintaining cursor position" })
map.set('n', '<Tab>', '>>_', { noremap = true, silent = true, desc = "Indent in normal mode using tab" })
map.set('n', '<S-Tab>', '<<_', { noremap = true, silent = true, desc = "Dedent in normal mode using tab" })
map.set('v', '<Tab>', '>gv', { noremap = true, silent = true, desc = "Indent in normal mode using tab" })
map.set('v', '<S-Tab>', '<gv', { noremap = true, silent = true, desc = "Dedent in normal mode using tab" })
