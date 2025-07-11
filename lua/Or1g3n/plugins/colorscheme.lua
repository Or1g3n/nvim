-- Define your preferred default colorscheme here
local default_colorscheme = "catppuccin"
local load_all = true  -- Set to true to load all colorschemes eagerly

return {
    {
	'folke/tokyonight.nvim',
	lazy = not (load_all or default_colorscheme == 'tokyonight'),  -- Eagerly load if default or load_all is true
	priority = 1000,
	config = function()
	    require('tokyonight').setup({
		style = "storm",
		transparent = false,
		terminal_colors = true,
		styles = {
		    floats = "transparent",
		},
	    })
	    if default_colorscheme == "tokyonight" then
		vim.cmd([[colorscheme tokyonight]])
	    end
	end,
    },
    {
	"rose-pine/neovim",
	name = "rose-pine",
	lazy = not (load_all or default_colorscheme == 'rose-pine'),  -- Eagerly load if default or load_all is true
	priority = 1000,
	config = function()
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
		    transparency = false,
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
	    if default_colorscheme == "rose-pine" then
		vim.cmd([[colorscheme rose-pine]])
	    end
	end,
    },
    {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	lazy = not (load_all or default_colorscheme == 'catppuccin'),  -- Eagerly load if default or load_all is true
	config = function()
	    require('catppuccin').setup({
		flavour = "mocha", -- latte, frappe, macchiato, mocha
		background = { -- :h background
		    light = "latte",
		    dark = "mocha",
		},
		transparent_background = false, -- disables setting the background color.
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
	    if default_colorscheme == "catppuccin" then
		vim.cmd([[colorscheme catppuccin]])
	    end
	end,

    },
    {
	'rebelot/kanagawa.nvim',
	lazy = not (load_all or default_colorscheme == 'kanagawa'),  -- Eagerly load if default or load_all is true
	priority = 1000,
	config = function()
	    require('kanagawa').setup({
		compile = false,             -- enable compiling the colorscheme
		undercurl = true,            -- enable undercurls
		commentStyle = { italic = true },
		functionStyle = {},
		keywordStyle = { italic = true},
		statementStyle = { bold = true },
		typeStyle = {},
		transparent = false,         -- do not set background color
		dimInactive = false,         -- dim inactive window `:h hl-NormalNC`
		terminalColors = true,       -- define vim.g.terminal_color_{-1,17}
		colors = {                   -- add/modify theme and palette colors
		    palette = {},
		    theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
		},
		overrides = function(colors) -- add/modify highlights
		    return {}
		end,
		theme = "wave",              -- Load "wave" theme when 'background' option is not set
		background = {               -- map the value of 'background' option to a theme
		    dark = "wave",           -- try "dragon" !
		    light = "lotus"
		},
	    })
	    if default_colorscheme == "kanagawa" then
		vim.cmd([[colorscheme kanagawa]])
	    end
	end,
    },
}
