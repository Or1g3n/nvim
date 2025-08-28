return{
    'saghen/blink.cmp',
    enabled = true,
    dependencies = 'rafamadriz/friendly-snippets',
    -- use a release tag to download pre-built binaries
    version = 'v0.*',
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
	-- 'default' for mappings similar to built-in completion
	-- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
	-- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
	-- see the "default configuration" section below for full documentation on how to define
	-- your own keymap.
	keymap = {
	    ['<C-n>'] = { 'show', 'show_documentation', 'hide_documentation' },
	    ['<C-e>'] = { 'hide' },
	    ['<C-y>'] = { 'select_and_accept' },
	    ['<Tab>'] = { 'select_and_accept', 'snippet_forward', 'fallback' },
	    ['<S-Tab>'] = { 'snippet_backward', 'fallback' },

	    ['<Up>'] = { 'select_prev', 'fallback' },
	    ['<Down>'] = { 'select_next', 'fallback' },
	    ['<C-k>'] = { 'select_prev', 'fallback' },
	    ['<C-j>'] = { 'select_next', 'fallback' },
	    ['<C-l>'] = { 'fallback' },
	    ['<C-h>'] = { 'fallback' },

	    ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
	    ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
	},
	completion = {
	    menu = {
		auto_show = function()
		    return vim.bo.buftype ~= "prompt" and vim.b.completion ~= false and vim.bo.filetype ~= "TelescopePrompt"
		end,
		border = 'rounded'
	    },
	    documentation = {
		window = { border = 'rounded' }
	    },
	},
	appearance = {
	    -- Sets the fallback highlight groups to nvim-cmp's highlight groups
	    -- Useful for when your theme doesn't support blink.cmp
	    -- will be removed in a future release
	    use_nvim_cmp_as_default = true,
	    -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
	    -- Adjusts spacing to ensure icons are aligned
	    nerd_font_variant = 'mono'
	},
	-- default list of enabled providers defined so that you can extend it
	-- elsewhere in your config, without redefining it, due to `opts_extend`
	sources = {
	    default = { 'lsp', 'path', 'snippets', 'buffer' },
	    per_filetype = {
		sql = { 'snippets', 'dadbod', 'buffer' },
	    },
	    providers = {
		cmdline = {
		    -- ignores cmdline completions when executing shell commands
		    enabled = function()
			return vim.fn.getcmdtype() ~= ':' or not vim.fn.getcmdline():find("!")
		    end
		},
		dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
	    }
	},
	-- experimental signature help support
	signature = {
	    enabled = true,
	    window = { border = 'rounded' }
	},
	cmdline = {
	    enabled = true,
	    keymap = {
		preset = 'inherit'
	    },
	    completion = {
		menu = {
		    auto_show = true
		}
	    },
	},
    },
}
