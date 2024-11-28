return {
    "benlubas/molten-nvim",
    version = "^1.0.0", -- use version <2.0.0 to avoid breaking changes
    build = ":UpdateRemotePlugins",
    init = function()
	local map = vim.keymap

	vim.g.molten_output_win_max_height = 12
	vim.g.molten_auto_open_output = false
	vim.g.molten_wrap_output = true

	vim.g.molten_virt_text_output = true
	-- vim.g.molten_virt_lines_off_by_1 = true

	map.set("n", "<A-r><A-i>", ":MoltenInit<CR>", { silent = true, desc = "Molten: Initialize plugin" })
	map.set("n", "<A-r><A-t>", ":MoltenDeinit<CR>", { silent = true, desc = "Molten: De-initialize plugin" })
	map.set("n", "<A-r><A-d>", ":MoltenDelete<CR>", { silent = true, desc = "Molten: Delete cell" })

	map.set("n", "<A-r><A-e>", ":MoltenEvaluateOperator<CR>", { silent = true, desc = "Molten: Run operator selection" })
	map.set("n", "<A-r><A-r>", ":MoltenEvaluateLine<CR>", { silent = true, desc = "Molten: Evaluate line" })
	map.set("n", "<A-r><A-c>", ":MoltenReevaluateCell<CR>", { silent = true, desc = "Molten: Re-evaluate cell" })
	map.set("v", "<A-r>", 	   ":<C-u>MoltenEvaluateVisual<CR>gv", { silent = true, desc = "Molten: Evaluate visual selection" })

	map.set("n", "<A-r><A-h>", ":MoltenHideOutput<CR>", { silent = true, desc = "Molten: Hide output" })
	map.set("n", "<A-r><A-o>", ":noautocmd MoltenEnterOutput<CR>", { silent = true, desc = "Molten: Show/enter output" })

	map.set("n", "<A-r><A-n>", ":MoltenNext<CR>", { silent = true, desc = "Molten: Goto next cell" })
	map.set("n", "<A-r><A-p>", ":MoltenPrev<CR>", { silent = true, desc = "Molten: Goto previous cell" })

    end,
}
