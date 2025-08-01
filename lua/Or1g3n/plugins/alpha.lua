return {
    "goolord/alpha-nvim",
    enabled = true,
    dependencies = {
	"nvim-tree/nvim-web-devicons",
    },

    config = function()
	local alpha = require("alpha")
	local dashboard = require("alpha.themes.dashboard")
	local customutils = require("Or1g3n.core.custom.utils")

	-- Update this to whatever greeting messsage file
	local greeting = customutils.safe_require("Or1g3n.plugins.local.alpha.greeting", "Welcome to Neovim!")

	-- Update this to whatever random messsage file you like
	local messages = customutils.safe_require("Or1g3n.plugins.local.alpha.messages", {{ message = "Make it a great day." }})
	local function load_random_message()
	    if #messages == 0 then
		return ""
	    end
	    local random_index = vim.fn.rand() % #messages + 1
	    return messages[random_index].message
	end

	dashboard.section.header.val = {
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
	}

	dashboard.section.buttons.val = {
	    dashboard.button("o", "  Open last session", ":source ~/.nvim-sessions/session.vim <CR>"), -- Note this assumes that vim-obsession config exists with global session_file defined
	    dashboard.button("n", "  New file", ":enew <CR>"),
	    dashboard.button("f", "󰈞  Find file", ":lua Snacks.picker.files() <CR>"),
	    dashboard.button("r", "󰈢  Recent files", ":lua Snacks.picker.recent() <CR>"),
	    dashboard.button("e", "  Open explorer", ":lua require('mini.files').open()<CR>"),
	    dashboard.button("h", "  Open help search", ":lua Snacks.picker.help() <CR>"), -- Note this assumes that vim-obsession config exists with global session_file defined
	    dashboard.button("t", "  Open todos list", ":MarkdownUpdateTodos <CR>"), -- Note this assumes that vim-obsession config exists with global session_file defined
	    dashboard.button("c", "  Search config files", ":lua Snacks.picker.files({ cwd= vim.fn.stdpath('config') }) <CR>"),
	    dashboard.button(".", "  Show commands", ":lua Snacks.picker.commands() <CR>"),
	    dashboard.button("?", "  Show keymaps", ":lua Snacks.picker.keymaps() <CR>"),
	    dashboard.button("u", "  Change color-scheme", ":lua Snacks.picker.colorschemes() <CR>"),
	    dashboard.button("l", "󰒲  Open lazy package manager", ":Lazy <CR>"),
	    dashboard.button("m", "󱌢  Open mason lsp manager", ":Mason <CR>"),
	    dashboard.button("q", "󰩈  Quit Neovim", ":qa<CR>"),
	}

	local function get_max_footer_width(lines)
	    local max_width = 0
	    for _, line in ipairs(lines) do
		local strwidth = vim.fn.strdisplaywidth(line)
		if strwidth > max_width then
		    max_width = strwidth
		end
	    end
	    return max_width
	end

	local function center_line(line, width)
	    local strwidth = vim.fn.strdisplaywidth(line)
	    if strwidth >= width then return line end
	    local pad = math.floor((width - strwidth) / 2)
	    return string.rep(" ", pad) .. line
	end

	local function center_footer_lines(lines)
	    local width = get_max_footer_width(lines)
	    local centered = {}
	    for _, line in ipairs(lines) do
		table.insert(centered, center_line(line, width))
	    end
	    return centered
	end

	-- Set keymaps
	local map = vim.keymap

	map.set('n', '<A-a>', ':Alpha <CR>' , { noremap = true, silent = true, desc = 'Alpha: Open Alpha splash screen' })

	-- Setup alpha
	alpha.setup(dashboard.config)

	-- Draw Footer After Startup
	vim.api.nvim_create_autocmd("User", {
	    once = true,
	    pattern = "LazyVimStarted",
	    callback = function()
		local footer_lines = {
		    "",
		    greeting,
		    load_random_message(),
		    "",
		}
		local stats = require("lazy").stats()
		local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)

		-- Footer
		table.insert(footer_lines, "⚡ Neovim loaded "
		    .. stats.loaded
		    .. "/"
		    .. stats.count
		    .. " plugins in "
		    .. ms
		    .. "ms")
		dashboard.section.footer.val = center_footer_lines(footer_lines)

		pcall(vim.cmd.AlphaRedraw)
		dashboard.section.footer.opts.hl = "AlphaFooter"
	    end,
	})

    end
}
