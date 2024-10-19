local options = {
    -- UI
    termguicolors = true,
    winblend = 10,
    -- Indentation
    autoindent = true,
    smartindent = true,
    shiftwidth = 4,
    -- Lines
    number = true,
    relativenumber = true,
    scrolloff = 10,
    -- Search
    hlsearch = false,
    incsearch = true,
    ignorecase = true,
    smartcase = true,
    -- File
    title = false,
}

for option, value in pairs(options) do vim.opt[option] = value end
