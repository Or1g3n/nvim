-- lua/MyUser/plugins/debug/nvim-dap-python.lua
return {
    'mfussenegger/nvim-dap-python',
    dependencies = { 'mfussenegger/nvim-dap' },
    ft = 'python',
    config = function()
	require('dap-python').setup('python')  -- Adjust if you need a specific virtual environment path
    end,
}

