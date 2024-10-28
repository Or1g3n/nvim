return {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = { 
	'nvim-lua/plenary.nvim',
	{ 'nvim-telescope/telescope-fzf-native.nvim', build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release; cmake --build build --config Release' }, -- for windows must install c++ builds tools (CMake and SDK for Windows 10/11 then add cmake.exe to path)
	'nvim-tree/nvim-web-devicons',
    },
    config = function()
	local telescope = require('telescope')
	local actions = require('telescope.actions')

	telescope.setup({
	    defaults = {
		mappings = {
		    i = {
			["<esc>"] = require('telescope.actions').close, -- close telescope picker
			['<C-k>'] = actions.move_selection_previous, -- move to prev result
			['<C-j>'] = actions.move_selection_next, -- move to next result
			['<C-q>'] = actions.send_selected_to_qflist + actions.open_qflist,
		    }
		}
	    }
	})

	telescope.load_extension('fzf');

	-- set keymaps
	local map = vim.keymap

	map.set('n', '<leader><leader>', ':Telescope find_files<CR>', { desc = 'Fuzzy find files in cwd' })
	map.set('n', '<leader>fb', ':Telescope buffers<CR>', { desc = 'Fuzzy find open buffers' })
	map.set('n', '<leader>fc', ':Telescope grep_string<CR>', { desc = 'Fuzzy string under cursor in cwd' })
	map.set('n', '<leader>fh', ':Telescope help_tags<CR>', { desc = 'Fuzzy find help tags' })
	map.set('n', '<leader>fr', ':Telescope oldfiles<CR>', { desc = 'Fuzzy find recent files' })
	map.set('n', '<leader>fs', ':Telescope live_grep<CR>', { desc = 'Fuzzy find string in cwd' })

    end
}
