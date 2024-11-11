return {
    'rcarriga/nvim-dap-ui',
    dependencies = {
	'mfussenegger/nvim-dap',
	'nvim-neotest/nvim-nio'
    },
    event = 'VeryLazy',
    config = function()
	local dap, dapui = require('dap'), require('dapui')
	local map = vim.keymap

	dapui.setup()

	-- Eval var under cursor
	map.set("n", "<A-d><A-e>",
	    function()
	        dapui.eval(nil, { enter = true}) 
	    end,
	    { desc = "DAP UI: Eval under cursor" }
	)
	-- Toggle UI
	map.set('n', '<A-d><A-u>', dapui.toggle, { desc = "DAP UI: Toggle UI" })

	dap.listeners.before.attach.dapui_config = function()
	    dapui.open()
	end
	dap.listeners.before.launch.dapui_config = function()
	    dapui.open()
	end
	dap.listeners.before.event_terminated.dapui_config = function()
	    dapui.close()
	end
	dap.listeners.before.event_exited.dapui_config = function()
	    dapui.close()
	end

    end,
}

