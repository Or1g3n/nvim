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
    swapfile = false,
}

-- Check if NuShell is executable and update shell options
-- https://github.com/nushell/integrations/blob/main/nvim/init.lua (for detailed descriptions of each setting)
if vim.fn.executable('nu') == 1 then
    options.sh = "nu"  					-- Set NuShell as the shell
    options.shellcmdflag = "--stdin --no-newline -c" 	-- Tells the shell to interpret strings passed from Neovim as commands
    options.shelltemp = false				-- When set to `false` the stdin pipe will be used instead
    -- options.shellslash = true   			-- Forces Neovim to use forward slashes
    options.shellredir = "out+err> %s" 			-- 
    options.shellxquote = ""    			-- Prevents extra quoting issues
    options.shellquote = ""				-- No quotes needed around commands; NuShell handles this internally
    options.shellxescape = ""				-- Not typically needed for NuShell since it handles escaping internally
    options.shellpipe = "| complete | update stderr { ansi strip } | tee { get stderr | save --force --raw %s } | into record"
end

-- Set all options
for option, value in pairs(options) do vim.opt[option] = value end

-- Match theme set by terminal
vim.cmd("highlight Normal ctermbg=NONE guibg=NONE")

-- Global configurations
vim.g.netrw_liststyle = 3 -- Set netrw (:Explorer) list style to tree

-- Markdown folding
vim.g.markdown_folding = 1
