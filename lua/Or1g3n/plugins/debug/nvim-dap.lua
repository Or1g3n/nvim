return {
    'mfussenegger/nvim-dap',
    config = function()
	local dap = require('dap')
	local map = vim.keymap

	-- Keymaps
	map.set('n', '<F5>', dap.continue, { desc = "DAP: Start/continue debugging" })
	map.set('n', '<F10>', dap.step_over, { desc = "DAP: Step over" })
	map.set('n', '<F11>', dap.step_into, { desc = "DAP: Step into" })
	map.set('n', '<F12>', dap.step_out, { desc = "DAP: Step out" })
	map.set('n', '<A-d><A-b>', dap.toggle_breakpoint, { desc = "DAP: Toggle breakpoint" })
	map.set('n', '<A-d>,<A-r>', dap.repl.open, { desc = "DAP: Open REPL" })
    end,
}

