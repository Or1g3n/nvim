return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		event = { "BufReadPre", "BufNewFile" },
		build = ":TSUpdate",
		dependencies = {
			"windwp/nvim-ts-autotag",
			"nvim-treesitter/nvim-treesitter-textobjects",
			"MeanderingProgrammer/treesitter-modules.nvim",
		},
		config = function()
			vim.treesitter.language.register("c_sharp", { "csharp", "c_sharp" })

			local languages = {
				"bash",
				"c",
				"css",
				"diff",
				"dockerfile",
				"gitignore",
				"graphql",
				"html",
				"javascript",
				"jsdoc",
				"json",
				"lua",
				"luadoc",
				"luap",
				"markdown",
				"markdown_inline",
				"nu",
				"printf",
				"python",
				"query",
				"regex",
				"sql",
				"toml",
				"tsx",
				"typescript",
				"vim",
				"vimdoc",
				"xml",
				"yaml",
			}

			-- Covers ensure_installed + highlight + indent + fold + incremental selection
			local ts = require("treesitter-modules")
			ts.setup({
				ensure_installed = languages,
				ignore_install = {},
				sync_install = false,
				auto_install = false,

				highlight = {
					enable = true,
				},
				indent = {
					enable = true,
				},
				fold = {
					enable = true,
				},
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "gnn",
						node_incremental = "grn",
						scope_incremental = "grc",
						node_decremental = "grm",
					},
				},
			})

			-- Fold settings
			vim.opt.foldmethod = "expr"
			vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"

			-- autotag
			require("nvim-ts-autotag").setup()

			-- textobjects plugin now uses its own setup + keymaps
			require("nvim-treesitter-textobjects").setup({
				move = {
					set_jumps = false,
				},
				select = {
					lookahead = true,
				},
			})

			-- Custom text obects
			vim.keymap.set({ "n", "x", "o" }, "]b", function()
				require("nvim-treesitter-textobjects.move").goto_next_start("@code_cell.inner", "textobjects")
			end, { desc = "TS Custom: next code block" })

			vim.keymap.set({ "n", "x", "o" }, "<M-PageDown>", function()
				require("nvim-treesitter-textobjects.move").goto_next_start("@code_cell.inner", "textobjects")
			end, { desc = "TS Custom: next code block" })

			vim.keymap.set({ "n", "x", "o" }, "[b", function()
				require("nvim-treesitter-textobjects.move").goto_previous_start("@code_cell.inner", "textobjects")
			end, { desc = "TS Custom: previous code block" })

			vim.keymap.set({ "n", "x", "o" }, "<M-PageUp>", function()
				require("nvim-treesitter-textobjects.move").goto_previous_start("@code_cell.inner", "textobjects")
			end, { desc = "TS Custom: previous code block" })

			vim.keymap.set({ "x", "o" }, "ib", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@code_cell.inner", "textobjects")
			end, { desc = "TS Custom: in code block" })

			vim.keymap.set({ "x", "o" }, "ab", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@code_cell.outer", "textobjects")
			end, { desc = "TS Custom: around code block" })
		end,
	},
}
