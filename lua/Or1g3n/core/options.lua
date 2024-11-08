local options = {
    -- UI
    termguicolors = true,
    showmode = false, -- set to false if lualine plugin enabled
    -- Indentation
    autoindent = true,
    smartindent = true,
    shiftwidth = 4,
    -- Lines
    number = true,
    relativenumber = true,
    scrolloff = 10,
    cursorline = true,
    -- Search
    hlsearch = false,
    incsearch = true,
    ignorecase = true,
    smartcase = true,
    -- File
    title = false,
    --Shell
    sh = "nu.exe"
}
-- Set all options
for option, value in pairs(options) do vim.opt[option] = value end

-- Match theme set by terminal
vim.cmd("highlight Normal ctermbg=NONE guibg=NONE")

-- Global configurations
vim.g.netrw_liststyle = 3 -- Set netrw (:Explorer) list style to tree 

-- Markdown folding
vim.g.markdown_folding = 1
