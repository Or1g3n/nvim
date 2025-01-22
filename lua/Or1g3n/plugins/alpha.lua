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
	    dashboard.button("f", "󰈞  Find file", ":lua Snacks.picker.files() <CR>"),
            dashboard.button("r", "󰈢  Recent files", ":lua Snacks.picker.recent() <CR>"),
            dashboard.button("e", "  Open explorer", ":lua require('mini.files').open()<CR>"),
	    dashboard.button("h", "  Open help search", ":lua Snacks.picker.help() <CR>"), -- Note this assumes that vim-obsession config exists with global session_file defined
	    dashboard.button("t", "  Open todos list", ":MarkdownUpdateTodos <CR>"), -- Note this assumes that vim-obsession config exists with global session_file defined
            dashboard.button("sc", "  Search config files", ":lua Snacks.picker.files({ cwd= vim.fn.stdpath('config') }) <CR>"),
            dashboard.button("cm", "  Show commands", ":lua Snacks.picker.commands() <CR>"),
            dashboard.button("?", "  Show keymaps", ":lua Snacks.picker.keymaps() <CR>"),
            dashboard.button("cs", "  Change color-scheme", ":lua Snacks.picker.colorschemes() <CR>"),
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
