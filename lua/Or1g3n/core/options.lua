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
    linebreak = true,
    -- Search
    hlsearch = false,
    incsearch = true,
    ignorecase = true,
    smartcase = true,
    -- File
    title = false,
    --Shell
    sh = "nu.exe",
    shellcmdflag = "-c", -- Tells the shell to interpret strings passed from Neovim as commands
    -- shellslash = true,   -- Forces Neovim to use forward slashes
    shellxquote = "",    -- Prevents extra quoting issues
    shellquote = "",	 -- No quotes needed around commands; NuShell handles this internally
    shellxescape = ""	 -- Not typically needed for NuShell since it handles escaping internally
}
-- Set all options
for option, value in pairs(options) do vim.opt[option] = value end

-- Match theme set by terminal
vim.cmd("highlight Normal ctermbg=NONE guibg=NONE")

-- Global configurations
vim.g.netrw_liststyle = 3 -- Set netrw (:Explorer) list style to tree

-- Markdown folding
vim.g.markdown_folding = 1
