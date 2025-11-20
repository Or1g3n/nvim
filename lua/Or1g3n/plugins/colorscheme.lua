-- Define your preferred default colorscheme here
local default_colorscheme = "catppuccin"
local load_all = true -- Set to true to load all colorschemes eagerly
vim.o.background = 'dark' -- Set to 'dark', 'light'; plugins will adapt if they support it

-- Set global transparent background option
vim.g.transparent_background = true -- Set to true for transparent background

-- Define colorscheme to plugin mapping; this is neeced to handle different variants
-- and to identify which plugin to configure when a colorscheme is applied
local colorscheme_plugin_map = {
    ['catppuccin-frappe'] = 'catppuccin',
    ['catppuccin-macchiato'] = 'catppuccin',
    ['catppuccin-mocha'] = 'catppuccin',
    ['rose-pine'] = 'rose-pine',
    ['rose-pine-dawn'] = 'rose-pine',
    ['rose-pine-moon'] = 'rose-pine',
    ['rose-pine-main'] = 'rose-pine',
    ['tokyonight-day'] = 'tokyonight',
    ['tokyonight-moon'] = 'tokyonight',
    ['tokyonight-night'] = 'tokyonight',
    ['tokyonight-storm'] = 'tokyonight',
    catppuccin = 'catppuccin',
    kanagawa = 'kanagawa',
    tokyonight = 'tokyonight',
}

-- Colorscheme setup functions for customization
local colorscheme_setups = {
    tokyonight = function(is_transparent)
	require('tokyonight').setup({
	    style = "night", -- night, storm, moon, day
	    light_style = "day",
	    transparent = is_transparent,
	    terminal_colors = true,
	    styles = {
		floats = "transparent",
	    },
	    on_colors = function(c)
		if is_transparent then
		    c.bg_statusline = c.none
		end
	    end,
	})
    end,

    ['rose-pine'] = function(is_transparent)
	require("rose-pine").setup({
	    variant = "auto", -- auto, main, moon, or dawn
	    dark_variant = "main", -- main, moon, or dawn
	    dim_inactive_windows = false,
	    extend_background_behind_borders = true,
	    enable = {
		terminal = true,
		legacy_highlights = true, -- Improve compatibility for previous versions of Neovim
		migrations = true, -- Handle deprecated options automatically
	    },
	    styles = {
		bold = true,
		italic = true,
		transparency = is_transparent,
	    },
	    groups = {
		border = "muted",
		link = "iris",
		panel = "surface",
		error = "love",
		hint = "iris",
		info = "foam",
		note = "pine",
		todo = "rose",
		warn = "gold",
		git_add = "foam",
		git_change = "rose",
		git_delete = "love",
		git_dirty = "rose",
		git_ignore = "muted",
		git_merge = "iris",
		git_rename = "pine",
		git_stage = "iris",
		git_text = "rose",
		git_untracked = "subtle",
		h1 = "iris",
		h2 = "foam",
		h3 = "rose",
		h4 = "gold",
		h5 = "pine",
		h6 = "foam",
	    },
	    palette = {
		-- Override the builtin palette per variant
		-- moon = {
		--     base = '#18191a',
		--     overlay = '#363738',
		-- },
	    },
	    highlight_groups = {
		-- Comment = { fg = "foam" },
		-- VertSplit = { fg = "muted", bg = "muted" },
	    },
	    before_highlight = function(group, highlight, palette)
		-- Disable all undercurls
		-- if highlight.undercurl then
		--     highlight.undercurl = false
		-- end
		--
		-- Change palette colour
		-- if highlight.fg == palette.pine then
		--     highlight.fg = palette.foam
		-- end
	    end,
	})
    end,

    catppuccin = function(is_transparent)
	require('catppuccin').setup({
	    flavour = "auto", -- auto, latte, frappe, macchiato, mocha
	    background = { -- :h background
		light = "latte",
		dark = "mocha",
	    },
	    transparent_background = is_transparent, -- disables setting the background color.
	    float = {
		transparent = true, -- enable transparent floating windows
		solid = false, -- use solid styling for floating windows, see |winborder|
	    },
	    show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
	    term_colors = true, -- sets terminal colors (e.g. `g:terminal_color_0`)
	    dim_inactive = {
		enabled = false, -- dims the background color of inactive window
		shade = "dark",
		percentage = 0.15, -- percentage of the shade to apply to the inactive window
	    },
	    no_italic = false, -- Force no italic
	    no_bold = false, -- Force no bold
	    no_underline = false, -- Force no underline
	    styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
		comments = { "italic" }, -- Change the style of comments
		conditionals = { "italic" },
		loops = {},
		functions = {},
		keywords = {},
		strings = {},
		variables = {},
		numbers = {},
		booleans = {},
		properties = {},
		types = {},
		operators = {},
		-- miscs = {}, -- Uncomment to turn off hard-coded styles
	    },
	    lsp_styles = { -- Handles the style of specific lsp hl groups (see `:h lsp-highlight`).
		virtual_text = {
		    errors = { "italic" },
		    hints = { "italic" },
		    warnings = { "italic" },
		    information = { "italic" },
		    ok = { "italic" },
		},
		underlines = {
		    errors = { "underline" },
		    hints = { "underline" },
		    warnings = { "underline" },
		    information = { "underline" },
		    ok = { "underline" },
		},
		inlay_hints = {
		    background = true,
		},
	    },
	    color_overrides = {},
	    custom_highlights = {},
	    default_integrations = true,
	    integrations = {
		cmp = true,
		gitsigns = true,
		nvimtree = true,
		treesitter = true,
		notify = false,
		mini = {
		    enabled = true,
		    indentscope_color = "",
		},
		-- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
	    },
	})
    end,

    kanagawa = function(is_transparent)
	require('kanagawa').setup({
	    compile = false,              -- enable compiling the colorscheme
	    undercurl = true,             -- enable undercurls
	    commentStyle = { italic = true },
	    functionStyle = {},
	    keywordStyle = { italic = true},
	    statementStyle = { bold = true },
	    typeStyle = {},
	    transparent = is_transparent, -- do not set background color
	    dimInactive = false,          -- dim inactive window `:h hl-NormalNC`
	    terminalColors = true,        -- define vim.g.terminal_color_{-1,17}
	    colors = {                    -- add/modify theme and palette colors
		palette = {},
		theme = { wave = {}, lotus = {}, dragon = {},
		    all = {
			ui = {
			    bg_gutter = "none",  -- set background of non-current windows
			}
		    }
		},
	    },
	    overrides = function(colors) -- add/modify highlights
		local overrides = {}
		if is_transparent then
		    overrides.StatusLine = { bg = "none" }
		    overrides.StatusLineNC = { bg = "none" }
		end
		return overrides
	    end,
	    theme = "wave",              -- Load "wave" theme when 'background' option is not set
	    background = {               -- map the value of 'background' option to a theme
		dark = "wave",           -- try "dragon" !
		light = "lotus"
	    },
	})
    end,
}

-- Function to setup and apply the colorscheme
local function setup_colorscheme(scheme, is_transparent, set_to_active_theme)
    if colorscheme_setups[scheme] then
	colorscheme_setups[scheme](is_transparent)
	if set_to_active_theme then
	    vim.cmd('colorscheme ' .. scheme)
	end
    end
end

-- Set transparency for built-in colorschemes
local function set_builtin_transparency()
    vim.api.nvim_set_hl(0, "Normal", { ctermbg = "none", bg = "none" })
    vim.api.nvim_set_hl(0, "StatusLine", { ctermbg = "none", bg = "none" })
    vim.api.nvim_set_hl(0, "StatusLineNC", { ctermbg = "none", bg = "none" })
end

-- Function to toggle transparency
local function toggle_transparent_background()
    local current_theme = vim.g.colors_name or 'default'
    local theme_plugin = colorscheme_plugin_map[current_theme]
    vim.g.transparent_background = not vim.g.transparent_background

    if theme_plugin and colorscheme_setups[theme_plugin] then
	setup_colorscheme(theme_plugin, vim.g.transparent_background, true)
    else
	vim.cmd("colorscheme " .. current_theme)
	if vim.g.transparent_background then
	    set_builtin_transparency()
	end
    end
end

-- Create a user command and keymap to toggle transparency
vim.api.nvim_create_user_command(
    'ToggleTransparentBackground',
    toggle_transparent_background,
    { desc = 'Colorscheme: Toggle background transparency' }
)
vim.api.nvim_set_keymap('n', '<leader>tb', ':ToggleTransparentBackground<CR>', { noremap = true, silent = true, desc = 'Colorscheme: Toggle background transparency' })

-- Handle colorscheme changes to reapply transparency settings
-- This ensures that transparency settings persist whenever the colorscheme changes
vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function(args)
	local cs = args.match
	local plugin = colorscheme_plugin_map[cs] or cs
	if colorscheme_setups[plugin] then
	    setup_colorscheme(plugin, vim.g.transparent_background, false)
	elseif vim.g.transparent_background then
	    set_builtin_transparency()
	end
    end,
})

-- Handle case where default_colorscheme is set to built-in
if default_colorscheme and not colorscheme_plugin_map[default_colorscheme] then
    vim.cmd('colorscheme ' .. default_colorscheme) -- Apply the built-in colorscheme
    if vim.g.transparent_background then
	set_builtin_transparency()
    end
end

-- Lazy plugin specifications
return {
    {
	'folke/tokyonight.nvim',
	name = "tokyonight",
	lazy = not (load_all or default_colorscheme == 'tokyonight'),  -- Eagerly load if default or load_all is true
	priority = 1000,
	config = function()
	    setup_colorscheme("tokyonight", vim.g.transparent_background, default_colorscheme == 'tokyonight')
	end,
    },
    {
	"rose-pine/neovim",
	name = "rose-pine",
	lazy = not (load_all or default_colorscheme == 'rose-pine'),  -- Eagerly load if default or load_all is true
	priority = 1000,
	config = function()
	    setup_colorscheme("rose-pine", vim.g.transparent_background, default_colorscheme == 'rose-pine')
	end,
    },
    {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	lazy = not (load_all or default_colorscheme == 'catppuccin'),  -- Eagerly load if default or load_all is true
	config = function()
	    setup_colorscheme("catppuccin", vim.g.transparent_background, default_colorscheme == 'catppuccin')
	end,
    },
    {
	'rebelot/kanagawa.nvim',
	name = "kanagawa",
	lazy = not (load_all or default_colorscheme == 'kanagawa'),  -- Eagerly load if default or load_all is true
	priority = 1000,
	config = function()
	    setup_colorscheme("kanagawa", vim.g.transparent_background, default_colorscheme == 'kanagawa')
	end,
    },
}
