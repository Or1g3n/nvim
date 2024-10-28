return {
    'saghen/blink.cmp',
    lazy = false, -- lazy loading handled internally
    -- optional: provides snippets for the snippet source
    dependencies = 'rafamadriz/friendly-snippets',
    -- use a release tag to download pre-built binaries
    version = 'v0.*',
    -- OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    -- build = 'cargo build --release',
    -- If you use nix, you can build from source using latest nightly rust with:
    -- build = 'nix run .#build-plugin',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
	highlight = {
	    -- sets the fallback highlight groups to nvim-cmp's highlight groups
	    -- useful for when your theme doesn't support blink.cmp
	    -- will be removed in a future release, assuming themes add support
	    use_nvim_cmp_as_default = true,
	},
	-- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
	-- adjusts spacing to ensure icons are aligned
	nerd_font_variant = 'mono',

	-- experimental auto-brackets support
	-- accept = { auto_brackets = { enabled = true } },

	-- experimental signature help support
	-- trigger = { signature_help = { enabled = true } },

	-- for keymap, all values may be string | string[]
	-- use an empty table to disable a keymap
	keymap = {
	    show = '<C-space>',
	    hide = '<C-e>',
	    accept = '<Tab>',
	    select_and_accept = {},
	    select_prev = { '<Up>', '<C-p>', '<C-k>' },
	    select_next = { '<Down>', '<C-n>', '<C-j>' },

	    show_documentation = '<C-space>',
	    hide_documentation = '<C-space>',
	    scroll_documentation_up = '<C-b>',
	    scroll_documentation_down = '<C-f>',

	    snippet_forward = '<Tab>',
	    snippet_backward = '<S-Tab>',
	},
    }
}
