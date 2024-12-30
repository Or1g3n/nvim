return {
    "goolord/alpha-nvim",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },

    config = function()
        local alpha = require("alpha")
        local dashboard = require("alpha.themes.dashboard")

        dashboard.section.header.val = {
            [[                                                                       ]],
            [[                                                                       ]],
            [[                                                                       ]],
            [[                                                                       ]],
            [[                                                                     ]],
            [[       ████ ██████           █████      ██                     ]],
            [[      ███████████             █████                             ]],
            [[      █████████ ███████████████████ ███   ███████████   ]],
            [[     █████████  ███    █████████████ █████ ██████████████   ]],
            [[    █████████ ██████████ █████████ █████ █████ ████ █████   ]],
            [[  ███████████ ███    ███ █████████ █████ █████ ████ █████  ]],
            [[ ██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
            [[                                                                       ]],
            [[                                                                       ]],
            [[                                                                       ]],
        }

        dashboard.section.buttons.val = {
	    dashboard.button("o", "  Open last session", ":source ~/.nvim-sessions/session.vim <CR>"), -- Note this assumes that vim-obsession config exists with global session_file defined
            dashboard.button("n", "  New file", ":enew <CR>"),
	    dashboard.button("f", "󰈞  Find file", ":Telescope find_files <CR>"),
            dashboard.button("r", "󰈢  Recent files", ":lua require('telescope.builtin').oldfiles({ prompt_title = 'Recent Files' })<CR>"),
            dashboard.button("e", "  Open explorer", ":lua require('mini.files').open()<CR>"),
	    dashboard.button("h", "  Open help search", ":Telescope help_tags <CR>"), -- Note this assumes that vim-obsession config exists with global session_file defined
	    dashboard.button("t", "  Open todos list", ":MarkdownUpdateTodos <CR>"), -- Note this assumes that vim-obsession config exists with global session_file defined
            dashboard.button("sc", "  Search config files", ":lua require('telescope.builtin').find_files({ cwd= vim.fn.stdpath('config'), prompt_title = 'Find Config Files' })<CR>"),
            dashboard.button("cm", "  Show commands", ":Telescope commands <CR>"),
            dashboard.button("?", "  Show keymaps", ":Telescope keymaps <CR>"),
            dashboard.button("cs", "  Change color-scheme", ":Telescope colorscheme <CR>"),
            dashboard.button("l", "󰒲  Open lazy package manager", ":Lazy <CR>"),
            dashboard.button("m", "󱌢  Open mason lsp manager", ":Mason <CR>"),
            dashboard.button("q", "󰩈  Quit Neovim", ":qa<CR>"),
        }

        dashboard.section.footer.val = {
	    "                            ",  -- Extra padding lines to move footer down
	    "                            ",  -- Extra padding lines to move footer down
	    "                            ",  -- Extra padding lines to move footer down
	    "                            ",  -- Extra padding lines to move footer down
            " Welcome to Neovim, Christopher!",
        }

	-- Set keymaps
	local map = vim.keymap

	map.set('n', '<A-a>', ':Alpha <CR>' , { noremap = true, silent = true, desc = 'Alpha: Open Alpha splash screen' })

        -- Setup alpha
        alpha.setup(dashboard.config)
    end
}
