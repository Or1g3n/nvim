return {
    "quarto-dev/quarto-nvim",
    dependencies = {
        "jmbuhr/otter.nvim",
        "nvim-treesitter/nvim-treesitter",
    },
    ft = {"quarto", "markdown", "python"},
    config = function()
        local quarto = require("quarto")
        quarto.setup({
            lspFeatures = {
                languages = { "python", "lua" },
                chunks = "all",
                diagnostics = {
                    enabled = true,
                    triggers = { "BufWritePost" },
                },
                completion = {
                    enabled = true,
                },
            },
            keymap = {
                hover = "K",
                definition = "gd",
                rename = "<leader>rn",
                references = "gr",
                format = "<leader>gf",
            },
            codeRunner = {
                enabled = true,
                default_method = "molten",
            },
        })

        local runner = require("quarto.runner")

        -- Create an augroup for Quarto keymaps
        local augroup = vim.api.nvim_create_augroup("QuartoKeymaps", { clear = true })

	-- Function to set search term to markdown header to easily navigate cells with n, N
	local function set_search_term()
	    local ft_cell_tag = {
		ipynb = '```python',
	    }
	    local file_extension = vim.fn.bufname():match('^.+%.([^.]+)')
	    local cell_tag = ft_cell_tag[file_extension] or "No Match"
	    vim.cmd(":let @/ = '" .. cell_tag .. "'")
	end

        -- Function to set up buffer-local keymaps
        local function setup_quarto_keymaps(bufnr)
            vim.keymap.set("n", "<leader>xc", function() runner.run_cell(); set_search_term() end, { desc = "Quarto: run cell", silent = true, buffer = bufnr })
            vim.keymap.set("n", "<C-CR>", function() runner.run_cell(); set_search_term() end, { desc = "Quarto: run cell", silent = true, buffer = bufnr })
            vim.keymap.set("n", "<leader>xb", function() runner.run_cell(); set_search_term(); vim.cmd("normal ]b") end, { desc = "Quarto: run cell and goto next", silent = true, buffer = bufnr })
            vim.keymap.set("n", "<S-CR>", function() runner.run_cell(); set_search_term(); vim.cmd("normal ]b") end, { desc = "Quarto: run cell and goto next", silent = true, buffer = bufnr })
            vim.keymap.set("n", "<leader>xu", function() runner.run_above(); set_search_term() end, { desc = "Quarto: run cell and above", silent = true, buffer = bufnr })
            vim.keymap.set("n", "<leader>xa", function() runner.run_all(); set_search_term() end, { desc = "Quarto: run all cells", silent = true, buffer = bufnr })
            vim.keymap.set("n", "<leader>xl", function() runner.run_line(); set_search_term() end, { desc = "Quarto: run line", silent = true, buffer = bufnr })
            vim.keymap.set("n", "<leader>XA", function() runner.run_all(true); set_search_term() end, { desc = "Quarto: run all cells of all languages", silent = true, buffer = bufnr })
        end

        -- Function to check if Otter LSP is active for a buffer
        local function is_otter_active(bufnr)
            local clients = vim.lsp.get_clients({
                bufnr = bufnr,
                name = 'otter-ls[' .. bufnr .. ']'
            })
            return #clients > 0  -- Returns true if the Otter LSP client is attached
        end

        -- Set up autocommand for buffer enter
        vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
            group = augroup,
            pattern = {"*.qmd", "*.md", "*.ipynb"},
            callback = function(args)
                local bufnr = args.buf
                if is_otter_active(bufnr) then
                    setup_quarto_keymaps(bufnr)
                end
            end,
        })
    end
}
