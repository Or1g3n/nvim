return {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
	'nvim-lua/plenary.nvim',
	{ 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' }, -- for windows must install mingw, gcc, make
	-- { 'nvim-telescope/telescope-fzf-native.nvim', build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release; cmake --build build --config Release' }, -- for windows must install c++ builds tools (CMake and SDK for Windows 10/11 then add cmake.exe to path)
	'nvim-tree/nvim-web-devicons',
    },
    config = function()
	local telescope = require('telescope')
	local actions = require('telescope.actions')

	telescope.setup({
	    pickers = {
		find_files = {
		    hidden = false,
		    theme = "ivy"
		},
		oldfiles = {
		    theme = "ivy"
		},
		help_tags = {
		    theme = "ivy"
		},
	    },
	    defaults = {
		mappings = {
		    i = {
			-- ["<esc>"] = require('telescope.actions').close, -- close telescope picker
			['<C-k>'] = actions.move_selection_previous, -- move to prev result
			['<C-j>'] = actions.move_selection_next, -- move to next result
			['<C-q>'] = actions.send_selected_to_qflist + actions.open_qflist,
			['<C-s>'] = actions.select_vertical,
		    },
		    n = {
			['<C-s>'] = actions.select_vertical,
		    }
		},
		file_ignore_patterns = {
		    -- Version control
		    "^%.git[\\/]",  -- Ignore Git directories
		    -- OS/System files
		    "%.dll$",  -- Windows DLLs
		    "%.exe$",  -- Windows executables
		    "%.tmp$",  -- Temp files
		    -- Fonts files
		    "%.[ot]tf$",  -- Font files
		    -- Application/Document files
		    "%.pdf$",  -- PDF files
		    "%.docx?$",  -- Word documents
		    "%.xlsx?$",  -- Excel files
		    "%.pptx?$",  -- PowerPoint files
		    -- Media files
		    "%.png$", "%.jpe?g$", "%.gif$",  -- Image files
		    "%.svg$", "%.ico$",  -- Vector/other images
		    "%.mp[34]$", "%.mkv$", "%.avi$", "%.mov$",  -- Video files
		    "%.wav$", "%.flac$", "%.aac$", "%.ogg$",  -- Audio files
		    -- Compressed archives
		    "%.zip$", "%.tar$", "%.tar.gz$", "%.rar$", "%.7z$",
		    -- Node/Package dependencies
		    "^node_modules[\\/]", "^vendor[\\/]",  -- Node.js and PHP dependencies
		    -- Large files for data/machine learning
		    "%.npz$", "%.h5$", "%.csv$", "%.tfrecord$",  -- Data files
		    "%.db$", "%.sqlite3?$",  -- Database files
		    "%.log$",  -- Log files
		    -- IDE/editor config
		    "^%.idea[\\/]", "^%.vscode[\\/]", "^%.nuget[\\/]", -- IDE settings (IntelliJ, VSCode)
		    "%.swp$", "%.swo$",  -- Vim swap files
		    "^__pycache__[\\/]",  -- Python bytecode cache
		},
	    }
	})

	telescope.load_extension('fzf');

	-- set keymaps
	local map = vim.keymap

	-- map.set('n', '<leader><leader>', ':Telescope find_files<CR>', { desc = 'Fuzzy find files in cwd' })
	map.set('n', '<leader><leader>', ':Telescope find_files <CR>', { desc = 'Telescope: Fuzzy find files in cwd' })
	map.set('n', '<leader>fb', ':Telescope buffers<CR>', { desc = 'Telescope: Fuzzy find open buffers' })
	map.set('n', '<leader>fc', ':lua require("telescope.builtin").find_files({ cwd= vim.fn.stdpath("config"), prompt_title = "Find Config Files" })<CR>', { silent = true, desc = 'Telescope: Fuzzy find config files' })
	map.set('n', '<leader>fgc', ':Telescope grep_string<CR>', { desc = 'Telescope: Fuzzy find string under cursor in cwd' })
	map.set('n', '<leader>fh', ':Telescope help_tags<CR>', { desc = 'Telescope: Fuzzy find help tags' })
	map.set('n', '<leader>fr', ":lua require('telescope.builtin').oldfiles({ prompt_title = 'Recent Files' })<CR>", { desc = 'Telescope: Fuzzy find recent files' })
	map.set('n', '<leader>fgs', ':Telescope live_grep<CR>', { desc = 'Telescope: Fuzzy find string in cwd' })
	map.set('n', '<leader>fsp', ':Telescope spell_suggest<CR>', { desc = 'Telescope: Fuzzy find spell suggestions' })
	map.set('n', '<leader>ft', ':Telescope<CR>', { desc = 'Telescope: Fuzzy find Telescope functions' })

    end
}
