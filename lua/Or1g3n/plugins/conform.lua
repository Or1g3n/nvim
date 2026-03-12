return {
	"stevearc/conform.nvim",
	lazy = false,
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters = {
				ruff_format_ipynb_md = {
					meta = {
						url = "https://docs.astral.sh/ruff/",
						description = "Format jupytext-rendered .ipynb markdown via stdin (undo-safe).",
					},
					command = "ruff",
					args = function(self, ctx)
						local filename = vim.fn.fnamemodify(ctx.filename, ":t")
						local pseudo_name = filename:gsub("%.ipynb$", ".md")
						return {
							"format",
							"--preview",
							"--no-cache",
							"--stdin-filename",
							pseudo_name,
							"-",
						}
					end,
					stdin = true,
					condition = function(self, ctx)
						return ctx.filename and ctx.filename:match("%.ipynb$")
					end,
				},
			},

			formatters_by_ft = {
				javascript = { "prettier" },
				typescript = { "prettier" },
				javascriptreact = { "prettier" },
				typescriptreact = { "prettier" },
				svelte = { "prettier" },
				css = { "prettier" },
				html = { "prettier" },
				json = { "prettier" },
				yaml = { "prettier" },
				graphql = { "prettier" },
				liquid = { "prettier" },
				lua = { "stylua" },

				python = { "ruff_organize_imports", "ruff_format" },

				-- for markdown buffers:
				-- first try ipynb-specific formatter (only runs when filename ends .ipynb),
				-- then fallback to prettier for normal .md files
				markdown = function(bufnr)
					local filename = vim.api.nvim_buf_get_name(bufnr)
					if filename:match("%.ipynb$") then
						return { "ruff_format_ipynb_md" } -- no prettier for ipynb-backed buffers
					end
					return { "prettier" } -- normal markdown files
				end,
			},
		})

		vim.keymap.set({ "n", "v" }, "<leader>-", function()
			conform.format({
				lsp_fallback = true,
				async = false,
			})
		end, { desc = "Conform: organize imports + format" })
	end,
}
