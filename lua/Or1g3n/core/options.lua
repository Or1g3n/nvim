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
}

-- Check if NuShell is executable and update shell options
if vim.fn.executable('nu') == 1 then
    options.sh = "nu.exe"  	-- Set NuShell as the shell
    options.shellcmdflag = "-c" -- Tells the shell to interpret strings passed from Neovim as commands
    options.shellslash = true   -- Forces Neovim to use forward slashes
    options.shellxquote = ""    -- Prevents extra quoting issues
    options.shellquote = ""	-- No quotes needed around commands; NuShell handles this internally
    options.shellxescape = ""	-- Not typically needed for NuShell since it handles escaping internally
end

-- Set all options
for option, value in pairs(options) do vim.opt[option] = value end

-- Match theme set by terminal
vim.cmd("highlight Normal ctermbg=NONE guibg=NONE")

-- Global configurations
vim.g.netrw_liststyle = 3 -- Set netrw (:Explorer) list style to tree

-- Markdown folding
vim.g.markdown_folding = 1
