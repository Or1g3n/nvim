-- Set leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Load user config
if vim.g.vscode then
    require('vsvim.lazy')
else
    require('Or1g3n.core')
    require('Or1g3n.lazy')
end
