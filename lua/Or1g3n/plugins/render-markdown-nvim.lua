return {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
    config = function()
	local map = vim.keymap

	require('render-markdown').setup({
	    render_modes = true,
	    code = {
		-- Turn on / off code block & inline code rendering.
		enabled = true,
		-- Additional modes to render code blocks.
		render_modes = true,
		-- Turn on / off any sign column related rendering.
		sign = false,
		-- Determines how code blocks & inline code are rendered.
		-- | none     | disables all rendering                                                    |
		-- | normal   | highlight group to code blocks & inline code, adds padding to code blocks |
		-- | language | language icon to sign column if enabled and icon + name above code blocks |
		-- | full     | normal + language                                                         |
		style = 'full',
		-- Determines where language icon is rendered.
		-- | right | right side of code block |
		-- | left  | left side of code block  |
		position = 'left',
		-- Amount of padding to add around the language.
		-- If a float < 1 is provided it is treated as a percentage of available window space.
		language_pad = 0,
		-- Whether to include the language icon above code blocks.
		language_icon = true,
		-- Whether to include the language name above code blocks.
		language_name = false,
		-- A list of language names for which background highlighting will be disabled.
		-- Likely because that language has background highlights itself.
		-- Use a boolean to make behavior apply to all languages.
		-- Borders above & below blocks will continue to be rendered.
		disable_background = { 'diff' },
		-- Width of the code block background.
		-- | block | width of the code block  |
		-- | full  | full width of the window |
		width = 'full',
		-- Amount of margin to add to the left of code blocks.
		-- If a float < 1 is provided it is treated as a percentage of available window space.
		-- Margin available space is computed after accounting for padding.
		left_margin = 0,
		-- Amount of padding to add to the left of code blocks.
		-- If a float < 1 is provided it is treated as a percentage of available window space.
		left_pad = 0,
		-- Amount of padding to add to the right of code blocks when width is 'block'.
		-- If a float < 1 is provided it is treated as a percentage of available window space.
		right_pad = 0,
		-- Minimum width to use for code blocks when width is 'block'.
		min_width = 0,
		-- Determines how the top / bottom of code block are rendered.
		-- | none  | do not render a border                               |
		-- | thick | use the same highlight as the code body              |
		-- | thin  | when lines are empty overlay the above & below icons |
		-- | hide  | conceal lines unless language name or icon is added  |
		border = 'thick',
		-- Used above code blocks for thin border.
		above = '▄',
		-- Used below code blocks for thin border.
		below = '▀',
		-- Icon to add to the left of inline code.
		inline_left = '',
		-- Icon to add to the right of inline code.
		inline_right = '',
		-- Padding to add to the left & right of inline code.
		inline_pad = 0,
		-- Highlight for code blocks.
		highlight = 'RenderMarkdownCode',
		-- Highlight for language, overrides icon provider value.
		highlight_language = nil,
		-- Highlight for border, use false to add no highlight.
		highlight_border = 'RenderMarkdownCodeBorder',
		-- Highlight for language, used if icon provider does not have a value.
		highlight_fallback = 'RenderMarkdownCodeFallback',
		-- Highlight for inline code.
		highlight_inline = 'RenderMarkdownCodeInline',
	    },
	})

	-- Set keymaps
	map.set('n','<A-m><A-r>',':RenderMarkdown toggle<CR>', { noremap = true, silent = true, desc = 'Markdown: render markdown' })
    end
}
