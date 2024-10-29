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
	    dashboard.button("s", "  Open last session", ":source ~/.nvim-sessions/session.vim <CR>"), -- Note this assumes that vim-obsession config exists with global session_file defined
            dashboard.button("n", "  New file", ":enew <CR>"),
	    dashboard.button("f", "󰈞  Find file", ":Telescope find_files <CR>"),
            dashboard.button("r", "󰈢  Recent files", ":Telescope oldfiles <CR>"),
            dashboard.button("e", "  Open explorer", ":NvimTreeToggle <CR>"),
	    dashboard.button("h", "  Open help search", ":Telescope help_tags <CR>"), -- Note this assumes that vim-obsession config exists with global session_file defined
            -- dashboard.button("s", "  Settings", ":e ~/.config/nvim/init.lua <CR>"),
            dashboard.button("q", "󰩈  Quit Neovim", ":qa<CR>"),
        }

        dashboard.section.footer.val = {
	    "                            ",  -- Extra padding lines to move footer down
	    "                            ",  -- Extra padding lines to move footer down
	    "                            ",  -- Extra padding lines to move footer down
	    "                            ",  -- Extra padding lines to move footer down
	    "                            ",  -- Extra padding lines to move footer down
	    "                            ",  -- Extra padding lines to move footer down
            " Welcome to Neovim, Christopher!",
        }

        -- Setup alpha
        alpha.setup(dashboard.config)
    end
}
